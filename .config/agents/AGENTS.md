# Global instructions

- Never modify files, system configuration, or system state without my explicit confirmation, even when the permission mode would allow it. This includes anything run with sudo and anything outside the current project.
- When I ask you to "investigate", "look into", or "diagnose" something, find the cause and propose a fix with the exact commands, but don't apply it. Wait for my go-ahead.
- Read-only commands (ls, cat, grep, etc.) are fine to run without asking.
- I use Arch Linux. Never suggest apt/dnf commands; use pacman or yay (my daily driver for both repo and AUR packages), e.g. `yay -S fzf`.
- Prefer atomic commits: each commit does one thing and one thing well. Split unrelated changes (e.g. a refactor/fix vs. a new feature) into separate commits.
- In commits you create, end the message with an `Assisted-by: <agent>:<model id>` trailer (the January 2026 Linux kernel format) and no `Co-Authored-By` trailer. `<agent>` is the tool you're running in (e.g. `Claude`, `OpenCode`), and `<model id>` is your exact model ID with no provider or router prefix. For example, `Assisted-by: OpenCode:claude-opus-5-5`, not `openrouter/anthropic/claude-opus-5-5` or `databricks-claude-opus-5-5`. If you don't know your exact model ID, ask me. Don't guess.
- Never read secrets or credential files (e.g. `*secrets*`, `.env*`, `~/.ssh`, `~/.gnupg`, token/key files): their contents become tool output and get transmitted to the model gateway. Never use globs or recursive cat/grep over directories that may contain them; list filenames first and read only specific non-secret files. If a secrets file is the only way to answer, ask me. Filter or redact commands that can print secrets (`env`, `printenv`).
