#!/usr/bin/env bash
# Claude Code status line (Nord colors, OpenRouter / AI Gateway cost).
# Adapted from https://github.com/daniel3303/ClaudeCodeStatusLine (MIT).
#
# Model | dir@branch (+a -d) | tokens (%) | effort | ~$session | <spend> | vX.Y.Z
#
# <spend> depends on the backend, and is hidden when neither applies:
# - OpenRouter: "$balance left", needs OPENROUTER_API_KEY. Cached for 60s, shared
#   across sessions.
# - AI Gateway (ANTHROPIC_BASE_URL on localhost): "$spent/$cap today", read from
#   the gateway's /usage endpoint. The day resets at midnight UTC. The cap
#   defaults to $50 and can be overridden with CLAUDE_DAILY_CAP_USD.

set -f  # disable globbing

input=$(cat)

if [ -z "$input" ]; then
  printf "Claude"
  exit 0
fi

# Nord palette (https://www.nordtheme.com/docs/colors-and-palettes)
nord3='\033[38;2;76;86;106m'    # #4C566A separators, dim text
nord4='\033[38;2;216;222;233m'  # #D8DEE9 labels
nord7='\033[38;2;143;188;187m'  # #8FBCBB directory
nord8='\033[38;2;136;192;208m'  # #88C0D0 model
nord11='\033[38;2;191;97;106m'  # #BF616A critical, deletions
nord12='\033[38;2;208;135;112m' # #D08770 tokens, high usage
nord13='\033[38;2;235;203;139m' # #EBCB8B warning
nord14='\033[38;2;163;190;140m' # #A3BE8C ok, branch, additions
nord15='\033[38;2;180;142;173m' # #B48EAD xhigh effort
reset='\033[0m'

sep=" ${nord3}|${reset} "

# Format token counts (e.g., 50k / 200k / 1m)
format_tokens() {
  local num=$1
  if [ "$num" -ge 1000000 ]; then
    awk "BEGIN {v=sprintf(\"%.1f\",$num/1000000)+0; if(v==int(v)) printf \"%dm\",v; else printf \"%.1fm\",v}"
  elif [ "$num" -ge 1000 ]; then
    awk "BEGIN {printf \"%.0fk\", $num / 1000}"
  else
    printf "%d" "$num"
  fi
}

# Return color escape based on usage percentage
usage_color() {
  local pct=$1
  if [ "$pct" -ge 90 ]; then echo "$nord11"
  elif [ "$pct" -ge 70 ]; then echo "$nord12"
  elif [ "$pct" -ge 50 ]; then echo "$nord13"
  else echo "$nord14"
  fi
}

# File mtime in epoch seconds (GNU stat, then BSD stat)
file_mtime() {
  stat -c %Y "$1" 2>/dev/null || stat -f %m "$1" 2>/dev/null || echo 0
}

# ===== Extract data from JSON (single jq pass, one value per line) =====
{
  read -r model_name
  read -r cwd
  read -r size
  read -r current
  read -r effort_level
  read -r session_cost
  read -r cli_version
} < <(echo "$input" | jq -r '
  (.model.display_name // .model.id // "Claude"),
  (.workspace.current_dir // .cwd // ""),
  (.context_window.context_window_size // 200000),
  ((.context_window.current_usage // {}) as $u
    | ($u.input_tokens // 0) + ($u.cache_creation_input_tokens // 0) + ($u.cache_read_input_tokens // 0)),
  (.effort.level // ""),
  (.cost.total_cost_usd // ""),
  (.version // "")
')

model_name="${model_name#anthropic/}"
model_name="${model_name#databricks-}"
model_name=$(echo "$model_name" | sed 's/ *(\([0-9.]*[kKmM]*\) context)/ \1/')  # "(1M context)" → "1M"

[ "$size" -eq 0 ] 2>/dev/null && size=200000
pct_used=$(( current * 100 / size ))

if [ -z "$effort_level" ]; then
  effort_level="${CLAUDE_CODE_EFFORT_LEVEL:-}"
fi
if [ -z "$effort_level" ] && [ -f "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json" ]; then
  effort_level=$(jq -r '.effortLevel // empty' "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json" 2>/dev/null)
fi
[ -z "$effort_level" ] && effort_level="medium"

# ===== Build single-line output =====
out="${nord8}${model_name}${reset}"

# Current working directory and git branch
if [ -n "$cwd" ]; then
  out+="${sep}${nord7}${cwd##*/}${reset}"
  git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$git_branch" ]; then
    out+="${nord3}@${reset}${nord14}${git_branch}${reset}"
    git_stat=$(git -C "$cwd" diff --numstat 2>/dev/null | awk '{a+=$1; d+=$2} END {if (a+d>0) printf "+%d -%d", a, d}')
    [ -n "$git_stat" ] && out+=" ${nord3}(${reset}${nord14}${git_stat%% *}${reset} ${nord11}${git_stat##* }${reset}${nord3})${reset}"
  fi
fi

# Context window
out+="${sep}${nord12}$(format_tokens "$current")/$(format_tokens "$size")${reset}"
out+=" ${nord3}(${reset}$(usage_color "$pct_used")${pct_used}%${reset}${nord3})${reset}"

# Reasoning effort
out+="${sep}${nord4}effort:${reset} "
case "$effort_level" in
  low)    out+="${nord3}low${reset}" ;;
  medium) out+="${nord12}med${reset}" ;;
  high)   out+="${nord14}high${reset}" ;;
  xhigh)  out+="${nord15}xhigh${reset}" ;;
  max)    out+="${nord11}max${reset}" ;;
  *)      out+="${nord14}${effort_level}${reset}" ;;
esac

# Session cost: Claude Code's estimate at Anthropic list prices, hence "~"
if [ -n "$session_cost" ]; then
  out+="${sep}${nord4}~\$$(LC_NUMERIC=C printf '%.2f' "$session_cost")${reset} ${nord3}session${reset}"
fi

# ===== OpenRouter account balance (cached, 60s TTL) =====
if [ -n "$OPENROUTER_API_KEY" ]; then
  cache_dir="${TMPDIR:-/tmp}/claude"
  cache_file="$cache_dir/statusline-openrouter-credits.json"
  cache_max_age=60
  mkdir -p "$cache_dir" 2>/dev/null

  if [ $(( $(date +%s) - $(file_mtime "$cache_file") )) -ge "$cache_max_age" ]; then
    touch "$cache_file"  # stampede lock: prevent parallel sessions from fetching simultaneously
    response=$(curl -s --max-time 5 \
      -H "Authorization: Bearer $OPENROUTER_API_KEY" \
      "https://openrouter.ai/api/v1/credits" 2>/dev/null)
    # Only cache valid responses (not error JSON)
    if echo "$response" | jq -e '.data.total_credits' >/dev/null 2>&1; then
      echo "$response" > "$cache_file"
    fi
    # Remove the empty sentinel on failure so the next refresh retries
    [ -f "$cache_file" ] && [ ! -s "$cache_file" ] && rm -f "$cache_file"
  fi

  if [ -s "$cache_file" ]; then
    read -r balance used_pct < <(jq -r '.data
      | (.total_credits - .total_usage) as $left
      | "\($left) \(if .total_credits > 0 then (.total_usage * 100 / .total_credits | floor) else 100 end)"' "$cache_file")
    out+="${sep}$(usage_color "$used_pct")\$$(LC_NUMERIC=C printf '%.2f' "$balance")${reset} ${nord3}left${reset}"
  fi
# ===== AI Gateway daily spend (local proxy, no cache needed) =====
elif [[ "$ANTHROPIC_BASE_URL" =~ ^https?://(127\.0\.0\.1|localhost):[0-9]+/?$ ]]; then
  daily_cap="${CLAUDE_DAILY_CAP_USD:-50}"
  # /usage defaults to the current UTC day
  spent=$(curl -s --max-time 1 "${ANTHROPIC_BASE_URL%/}/usage" 2>/dev/null \
    | jq -r '.[-1].costUsd // empty' 2>/dev/null)
  if [ -n "$spent" ]; then
    spent_pct=$(awk -v s="$spent" -v c="$daily_cap" 'BEGIN {printf "%d", (c > 0 ? s * 100 / c : 0)}')
    out+="${sep}$(usage_color "$spent_pct")\$$(LC_NUMERIC=C printf '%.2f' "$spent")${reset}${nord3}/\$${daily_cap} today${reset}"
  fi
fi

# Claude Code version
[ -n "$cli_version" ] && out+="${sep}${nord3}v${cli_version}${reset}"

printf "%b" "$out"

exit 0
