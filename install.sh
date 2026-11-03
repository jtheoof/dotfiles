#!/usr/bin/env bash

set -e

DRY_RUN=${DRY_RUN:-0}

# TODO Install
#  * Fonts (especially Windows into /usr/share/fonts/truetype/windows)

declare -a commands
commands=(platform dotfiles)

# Print functions {{{

# Replace the home directory prefix with ~ to keep lines short.
shorten() {
  printf '%s' "${1//"$HOME"/'~'}"
}

print_debug() {
  echo "$(shorten "$1")"
}

print_info() {
  echo -e "\033[33m$(shorten "$1")\033[0m"
}

print_noop() {
  echo -e "\033[35m$(shorten "$1")\033[0m"
}

print_success() {
  echo -e "\033[32m$(shorten "$1")\033[0m"
}

print_error() {
  echo -e "\033[31m$(shorten "$1")\033[0m"
}

print_dry() {
  echo -e "\033[36m[dry-run] $(shorten "$1")\033[0m"
}

# Same as print_dry, and counts the action in the final summary.
print_dry_step() {
  DRY_STEPS=$((DRY_STEPS + 1))
  print_dry "$1"
}

# Counters for the final summary.
LINKS_NEW=0
LINKS_OK=0
LINKS_SKIP=0
LINKS_BACKUP=0
PKGS_NEW=0
PKGS_OK=0
DRY_STEPS=0

print_summary() {
  local total=$((LINKS_NEW + LINKS_OK + LINKS_SKIP + LINKS_BACKUP))

  if [ "$DRY_RUN" = 1 ]; then
    echo
    print_dry "Summary (nothing was changed):"
    if [ "$total" -gt 0 ]; then
      print_dry "  links:    $LINKS_NEW to create, $LINKS_BACKUP to back up and replace, $LINKS_SKIP to skip, $LINKS_OK already in place"
    fi
    if [ $((PKGS_NEW + PKGS_OK)) -gt 0 ]; then
      print_dry "  packages: $PKGS_NEW to install, $PKGS_OK already installed"
    fi
    if [ "$DRY_STEPS" -gt 0 ]; then
      print_dry "  other:    $DRY_STEPS step(s) would run (plugins, shell, yay, ...)"
    fi
  elif [ "$total" -gt 0 ]; then
    echo
    print_info "Summary:"
    print_info "  links: $LINKS_NEW created, $LINKS_BACKUP backed up and replaced, $LINKS_SKIP skipped, $LINKS_OK already in place"
    if [ "$LINKS_SKIP" -gt 0 ]; then
      print_error "  $LINKS_SKIP link(s) skipped because something else exists there; see warnings above or re-run with --force"
    fi
  fi
}

# }}}
# Utils {{{

die() {
  echo "$1"
  exit "${2:-1}"
}

usage() {
  cat <<EOF
Usage: install.sh [OPTIONS] [COMMAND]

Set up a new machine: install packages, symlink dotfiles, install plugins.
Safe to re-run: existing correct symlinks and installed packages are left
alone, so it can also be used to pick up newly added packages or links.

Supported systems: Arch Linux (and Manjaro), macOS (legacy)

Commands (default: run all steps):
  platform    install system packages only (yay on Arch, brew on macOS)
  dotfiles    create symlinks only (home dotfiles, ~/.config, ~/.local/bin,
              ~/.claude)

  With no command, the steps run in order: platform, dotfiles, tmux plugins
  (tpm), neovim plugins (Lazy), oh-my-zsh and its plugins, default shell.

Options:
  -f, --force   when a link destination already exists and is not the
                expected symlink (regular file, directory or a symlink to
                somewhere else), move it to <path>.bak.<timestamp> and link
                anyway. Without this flag such paths are skipped with a
                warning and nothing is overwritten.
  -n, --dry-run print what would be done (packages that would be installed,
                links that would be created, skipped or backed up, plugins
                that would be cloned...) without changing anything
  -h, --help    show this help and exit

Environment:
  XDG_CONFIG_HOME   config directory to link into (default: ~/.config)
  FORCE=1           same as --force
  DRY_RUN=1         same as --dry-run

Examples:
  ./install.sh                  full setup
  ./install.sh --dry-run        preview a full setup, change nothing
  ./install.sh dotfiles         only (re)create symlinks
  ./install.sh -n --force dotfiles  preview what --force would back up
  ./install.sh --force dotfiles replace conflicting files, keeping backups
EOF
}

# link SRC DEST
#
# Idempotent symlink creation. DEST is the full path of the link itself.
#  * already points to SRC: nothing to do
#  * nothing at DEST: create the link
#  * anything else (file, directory, foreign symlink): warn and skip, never
#    destroy or abort. With FORCE=1 the existing path is moved aside first.
# With DRY_RUN=1 only reports what would happen.
link() {
  local src=$1
  local dest=$2
  local kind=""
  local backup

  if [ -L "$dest" ] && [ "$(readlink -- "$dest")" = "$src" ]; then
    print_noop "already linked: $dest"
    LINKS_OK=$((LINKS_OK + 1))
    return 0
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ -L "$dest" ]; then
      kind="symlink to $(readlink -- "$dest")"
    elif [ -d "$dest" ]; then
      kind="directory"
    else
      kind="file"
    fi

    if [ "${FORCE:-0}" = 1 ]; then
      backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
      LINKS_BACKUP=$((LINKS_BACKUP + 1))
      if [ "$DRY_RUN" = 1 ]; then
        print_dry "would back up $dest ($kind) to $backup, then link -> $src"
        return 0
      fi
      print_info "backing up $dest to $backup"
      mv -- "$dest" "$backup"
    else
      LINKS_SKIP=$((LINKS_SKIP + 1))
      if [ "$DRY_RUN" = 1 ]; then
        print_dry "would skip $dest: existing $kind (use --force to back it up and replace it)"
        return 0
      fi
      print_error "skipping $dest: already exists ($kind) and is not the expected link (re-run with --force to back it up and replace it)"
      return 0
    fi
  fi

  LINKS_NEW=$((LINKS_NEW + 1))
  if [ "$DRY_RUN" = 1 ]; then
    print_dry "would link $dest -> $src"
    return 0
  fi

  mkdir -p -- "$(dirname -- "$dest")"
  ln -sT -- "$src" "$dest"
  print_success "linked: $dest -> $src"
}

# pacman_missing PKG...
#
# Prints the packages (one per line) that are not installed. Uses pacman -T,
# which exits 127 when something is missing, hence the || true.
pacman_missing() {
  pacman -T "$@" || true
}

# report_packages LABEL PKG...
#
# Dry-run report of which packages would be installed and which are already
# there.
report_packages() {
  local label=$1
  shift
  local missing
  local total=$#
  local count=0
  local p

  missing=$(pacman_missing "$@")
  if [ -n "$missing" ]; then
    count=$(printf '%s\n' "$missing" | wc -l)
  fi

  PKGS_NEW=$((PKGS_NEW + count))
  PKGS_OK=$((PKGS_OK + total - count))
  print_dry "$label: $((total - count)) already installed, $count would be installed"
  for p in $missing; do
    print_dry "  would install $p"
  done
}

# }}}
# Installers {{{

install_dotfiles() {
  local f
  local d

  print_info "installing dotfiles and folders"

  while IFS= read -r -d '' f; do
    link "$f" "$HOME/$(basename -- "$f")"
  done < <(find -H "$FILESPATH" -maxdepth 1 -type f \( -iname '.*' ! -iname '.gitattributes' ! -iname '.gitignore' \) -print0)

  # Link .vim directory
  link "$FILESPATH/.vim" "$HOME/.vim"

  # .config directories
  for d in "$FILESPATH"/.config/*; do
    link "$d" "$CONFIG_DIR/$(basename -- "$d")"
  done

  # .local directories
  link "$FILESPATH/.local/bin" "$HOME/.local/bin"

  # Claude Code: link individual files only, ~/.claude also holds credentials and history
  link "$FILESPATH/.claude/statusline.sh" "$HOME/.claude/statusline.sh"
  link "$FILESPATH/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  link "$FILESPATH/.claude/skills" "$HOME/.claude/skills"
}

install_tmux_plugins() {
  print_info "installing tmux plugin manager..."

  if [ -d "$CONFIG_DIR/tmux/plugins" ]; then
    print_info "tmux plugins folder found, skipping"
    return
  fi

  if [ "$DRY_RUN" = 1 ]; then
    print_dry_step "would clone tpm into $CONFIG_DIR/tmux/plugins/tpm and install tmux plugins"
    return
  fi

  git clone https://github.com/tmux-plugins/tpm "$CONFIG_DIR/tmux/plugins/tpm"

  print_info "installing tpm plugins..."
  sh -c "$CONFIG_DIR/tmux/plugins/tpm/bin/install_plugins"
}

# clone_omz_plugin NAME URL
clone_omz_plugin() {
  local name=$1
  local url=$2
  local dest="$ZSH_CUSTOM_PLUGINS_PATH/$name"

  if [ -d "$dest" ]; then
    print_noop "oh-my-zsh plugin already installed: $name"
  elif [ "$DRY_RUN" = 1 ]; then
    print_dry_step "would clone oh-my-zsh plugin $name into $dest"
  else
    print_debug "installing oh-my-zsh $name plugin"
    git clone "$url" "$dest"
  fi
}

install_oh_my_zsh() {
  local zsh_path
  local current_shell

  print_info "installing oh-my-zsh"
  if [ -d "$HOME/.oh-my-zsh" ]; then
    print_info "already found .oh-my-zsh at $HOME/.oh-my-zsh"
  elif [ "$DRY_RUN" = 1 ]; then
    print_dry_step "would install oh-my-zsh into $HOME/.oh-my-zsh"
  else
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended --keep-zshrc
  fi

  print_info "installing oh-my-zsh plugins"
  ZSH_CUSTOM_PLUGINS_PATH=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins

  clone_omz_plugin H-S-MW https://github.com/z-shell/H-S-MW
  clone_omz_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
  clone_omz_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git

  # switch to zsh default shell (only when it is not already)
  zsh_path=$(command -v zsh || true)
  current_shell=$(getent passwd "$(whoami)" | cut -d: -f7)
  if [ -z "$zsh_path" ]; then
    if [ "$DRY_RUN" = 1 ]; then
      print_dry "zsh not installed yet: default shell would be switched once it is"
    else
      print_error "zsh not found, not changing default shell"
    fi
  elif [ "$current_shell" = "$zsh_path" ]; then
    print_noop "default shell is already $zsh_path"
  elif [ "$DRY_RUN" = 1 ]; then
    print_dry_step "would switch default shell from $current_shell to $zsh_path"
  else
    print_info "switch to zsh..."
    sudo usermod --shell "$zsh_path" "$(whoami)"
  fi
}

install_yay() {
  print_info "installing yay..."

  if [ -x "$(command -v yay)" ]; then
    print_info "found yay at: $(command -v yay), skipping install"
  elif [ "$DRY_RUN" = 1 ]; then
    print_dry_step "would build and install yay-bin from the AUR"
  else
    cd "$(mktemp -d)"
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -sif --noconfirm
    cd "$FILESPATH"
  fi
}

install_packages_linux() {
  local packages=(
    alacritty
    bash
    bat
    binutils
    cargo
    colordiff
    coreutils
    cscope
    curl
    diffutils
    docker
    fastfetch
    fzf
    git
    git-delta
    gnupg
    grep
    gzip
    htop
    httpie
    imagemagick
    jq
    lazygit
    less
    lsof
    make
    neovim
    nodejs
    npm
    python
    python-neovim
    python-pip
    python-setuptools
    ripgrep
    scdoc
    sed
    tig
    tmux
    tree
    tree-sitter-cli
    unzip
    vim
    wget
    zoxide
    zsh
  )

  local aur_packages=(
    herdr-bin
    zsh-pure-prompt
  )

  if [ "$DRY_RUN" = 1 ]; then
    report_packages "packages" "${packages[@]}"
    report_packages "AUR packages" "${aur_packages[@]}"
    return
  fi

  print_info "installing packages..."
  yay -S --needed --noconfirm "${packages[@]}"

  print_info "installing AUR packages..."
  yay -S --needed --noconfirm "${aur_packages[@]}"
}

install_neovim_plugins() {
  print_info "installing neovim plugins..."
  if [ "$DRY_RUN" = 1 ]; then
    print_dry_step "would run: nvim --headless \"+Lazy! sync\" +qa (installs and updates lazy.nvim plugins)"
    return
  fi
  nvim --headless "+Lazy! sync" +qa
}

# macOS (legacy, no longer maintained) {{{

install_packages_darwin() {
  local brew_packages=(
    asciidoc
    bash
    certbot
    clang-format
    cloc
    colordiff
    ctags
    ctop
    curl
    direnv
    docker
    docker-compose
    dos2unix
    doxygen
    freetype
    fswatch
    git
    git-delta
    graphicsmagick
    grep
    herdr
    htop
    httpie
    jpeg
    jq
    kubernetes-cli
    kubernetes-helm
    lazygit
    md5deep
    mtr
    multimarkdown
    ncdu
    neofetch
    neovim
    ninja
    nmap
    node
    nvm
    openconnect
    openssh
    openvpn
    optipng
    pcre
    perl
    pidof
    pkg-config
    pngquant
    pure
    pyenv
    python
    python3
    ranger
    readline
    rename
    ripgrep
    rsync
    snappy
    ssh-copy-id
    terminal-notifier
    tig
    tldr
    tmux
    trash
    tree
    vim
    watch
    watchman
    webp
    wget
    yarn
    zoxide
    zsh
  )

  local brew_cask_packages=(
    1password
    1password-ci
    alfred
    appcleaner
    dropbox
    google-chrome
    iterm2
    macvim
    rectangle
    slack
    spotify
    visual-studio-code
  )

  if command -v brew > /dev/null 2>&1; then
    print_info "found homebrew at: $(command -v brew), skipping install"
  elif [ "$DRY_RUN" = 1 ]; then
    print_dry_step "would install homebrew, then ${#brew_packages[@]} brew packages and ${#brew_cask_packages[@]} casks"
    return
  else
    print_info "installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  if [ "$DRY_RUN" = 1 ]; then
    brew install --dry-run "${brew_packages[@]}" | sed 's/^/[dry-run] /' || true
    brew install --cask --dry-run "${brew_cask_packages[@]}" | sed 's/^/[dry-run] /' || true
    return
  fi

  print_info "installing brew packages..."
  brew install "${brew_packages[@]}"

  print_info "installing brew cask packages..."
  brew install --cask "${brew_cask_packages[@]}"
}

install_plist_launchd_darwin() {
  local label=me.jtheoof.launched.brew_update
  local plist="$HOME/Library/LaunchAgents/$label.plist"

  link "$FILESPATH/launchd/$label.plist" "$plist"

  if launchctl list | grep -q "$label"; then
    print_noop "launchd agent $label already loaded"
  elif [ "$DRY_RUN" = 1 ]; then
    print_dry_step "would load launchd agent $label"
  else
    launchctl load -w "$plist"
  fi
}

# }}}

# }}}
# Global variables {{{

FILESPATH=$HOME/.dotfiles
CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}

print_info "dotfiles directory: $FILESPATH"
print_info "config directory: $CONFIG_DIR"

# }}}
# Getting options {{{

COMMAND=""

while [ $# -gt 0 ]; do
  case "$1" in
    -h | --help)
      usage
      exit 0
      ;;
    -f | --force)
      FORCE=1
      ;;
    -n | --dry-run)
      DRY_RUN=1
      ;;
    -*)
      usage
      die "unknown option: $1"
      ;;
    *)
      [ -z "$COMMAND" ] || die "only one command can be given"
      COMMAND=$1
      ;;
  esac
  shift
done

if [ "$DRY_RUN" = 1 ]; then
  print_dry "DRY RUN: nothing will be installed, linked or modified"
fi

if [ -n "$COMMAND" ]; then
  case " ${commands[*]} " in
    *" $COMMAND "*) ;;
    *) usage; die "unknown command: $COMMAND" ;;
  esac
fi

# }}}

install_platform() {
  case "$OSTYPE" in
    linux*)
      if [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        . /etc/os-release
        OS_ID=$ID
      else
        die 'unable to read /etc/os-release'
      fi
      case "$OS_ID" in
        arch | manjaro)
          install_yay
          install_packages_linux
          ;;
        *)
          die "OS with ID: $OS_ID is not supported"
          ;;
      esac

      ;;
    darwin*)
      install_packages_darwin
      install_plist_launchd_darwin

      # Turn off the character accent selector and re-enable key repetition.
      if [ "$DRY_RUN" = 1 ]; then
        print_dry_step "would run: defaults write -g ApplePressAndHoldEnabled -bool false"
      else
        defaults write -g ApplePressAndHoldEnabled -bool false
      fi
      ;;
  esac
}

install_all() {
  if [ ! -d "$FILESPATH" ] && [ "$DRY_RUN" = 1 ]; then
    print_dry "would clone https://github.com/jtheoof/dotfiles into $FILESPATH (nothing else can be previewed before that)"
    return
  fi
  if [ ! -d "$FILESPATH" ]; then
    cd "$HOME"
    git clone --recursive https://github.com/jtheoof/dotfiles "$FILESPATH"
    cd "$FILESPATH"
  fi
  install_platform
  install_dotfiles
  install_tmux_plugins
  install_neovim_plugins
  install_oh_my_zsh
}

if [[ -n $COMMAND ]]; then
  case "$COMMAND" in
    platform)
      install_platform
      ;;
    dotfiles)
      install_dotfiles
      ;;
  esac
else
  install_all
fi

print_summary

# vim: sts=2 sw=2 et
