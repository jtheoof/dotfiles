function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function get_pwd() {
  print -D $PWD
}

function put_spacing() {
  local git=$(git_prompt_info)
  if [ ${#git} != 0 ]; then
    ((git=${#git} - 10))
  else
    git=0
  fi

  local termwidth
  (( termwidth = ${COLUMNS} - 3 - ${#USER} - ${#HOST} - ${#$(get_pwd)} - ${git} ))

  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing} "
  done
  echo $spacing
}

function precmd() {
  print -rP '
$fg[green]%n $fg_bold[red]%m $fg[cyan]$(get_pwd)$(put_spacing)$(git_prompt_info)'
}

# set VIMODE according to the current mode (default “[i]”)
VIMODE='[i]'
function zle-keymap-select {
  VIMODE="${${KEYMAP/vicmd/[n]}/(main|viins)/[i]}"
  zle reset-prompt
}

#zle -N zle-keymap-select
PROMPT='%{$reset_color%}# '

ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg_bold[red]"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"

# vim:sts=2:sw=2:et
