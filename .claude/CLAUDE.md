# Global instructions

- Never modify files, system configuration, or system state without my explicit confirmation, even when the permission mode would allow it. This includes anything run with sudo and anything outside the current project.
- When I ask you to "investigate", "look into", or "diagnose" something, find the cause and propose a fix with the exact commands, but don't apply it. Wait for my go-ahead.
- Read-only commands (ls, cat, grep, etc.) are fine to run without asking.
- I use Arch Linux. Never suggest apt/dnf commands; use pacman or yay (my daily driver for both repo and AUR packages), e.g. `yay -S fzf`.
- Prefer atomic commits: each commit does one thing and one thing well. Split unrelated changes (e.g. a refactor/fix vs. a new feature) into separate commits.
- In commits you create, keep the `Co-Authored-By: Claude <noreply@anthropic.com>` trailer and add an `Assisted-by: Claude:<model id>` trailer right after it (the January 2026 Linux kernel format), using your exact model id without any provider prefix, e.g. `Assisted-by: Claude:claude-opus-5-5` rather than `databricks-claude-opus-5-5`.
