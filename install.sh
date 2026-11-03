#!/usr/bin/env bash

set -e

# TODO Install
#  * Fonts (especially Windows into /usr/share/fonts/truetype/windows)

declare -a commands
commands=(platform dotfiles)

# Print functions {{{

print_debug() {
  echo "$1"
}

print_info() {
  echo -e "\033[33m$1\033[0m"
}

print_noop() {
  echo -e "\033[35m$1\033[0m"
}

print_success() {
  echo -e "\033[32m$1\033[0m"
}

print_error() {
  echo -e "\033[31m$1\033[0m"
}

# }}}
# Utils {{{

die() {
  echo "$1"
  exit "${2:-1}"
}

usage() {
  echo "Usage"
  echo
  echo "Installs basic tooling for new machine setup"
  echo
  echo "Supports"
  echo
  echo "  Arch Linux"
  echo "  macOS (legacy)"
  echo
  echo "Environment"
  echo
  echo "  FORCE=1  back up conflicting files to <path>.bak.<timestamp> and link anyway"
  echo
}

# link SRC DEST
#
# Idempotent symlink creation. DEST is the full path of the link itself.
#  * already points to SRC: nothing to do
#  * nothing at DEST: create the link
#  * anything else (file, directory, foreign symlink): warn and skip, never
#    destroy or abort. With FORCE=1 the existing path is moved aside first.
link() {
  local src=$1
  local dest=$2

  if [ -L "$dest" ] && [ "$(readlink -- "$dest")" = "$src" ]; then
    print_noop "already linked: $dest"
    return 0
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ "${FORCE:-0}" = 1 ]; then
      local backup
      backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
      print_info "backing up $dest to $backup"
      mv -- "$dest" "$backup"
    else
      print_error "skipping $dest: already exists and is not the expected link (re-run with FORCE=1 to back it up and replace it)"
      return 0
    fi
  fi

  mkdir -p -- "$(dirname -- "$dest")"
  ln -sT -- "$src" "$dest"
  print_success "linked: $dest -> $src"
}

# }}}
# Installers {{{

install_dotfiles() {
  local f
  local d

  print_info "installing dotfiles and folders"

  while IFS= read -r -d '' f; do
    link "$f" "$HOME/$(basename -- "$f")"
  done < <(find "$FILESPATH" -maxdepth 1 -type f \( -iname '.*' ! -iname '.gitattributes' ! -iname '.gitignore' \) -print0)

  # Link .vim directory
  link "$FILESPATH/.vim" "$HOME/.vim"

  # .config directories
  mkdir -p -- "$CONFIG_DIR"
  for d in "$FILESPATH"/.config/*; do
    link "$d" "$CONFIG_DIR/$(basename -- "$d")"
  done

  # .local directories
  mkdir -p -- "$HOME/.local"
  link "$FILESPATH/.local/bin" "$HOME/.local/bin"

  # Claude Code: link individual files only, ~/.claude also holds credentials and history
  mkdir -p -- "$HOME/.claude"
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

  git clone https://github.com/tmux-plugins/tpm "$CONFIG_DIR/tmux/plugins/tpm"

  print_info "installing tpm plugins..."
  sh -c "$CONFIG_DIR/tmux/plugins/tpm/bin/install_plugins"
}

install_oh_my_zsh() {
  local zsh_path
  local current_shell

  print_info "installing oh-my-zsh"
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended --keep-zshrc
  else
    print_info "already found .oh-my-zsh at $HOME/.oh-my-zsh"
  fi

  print_info "installing oh-my-zsh plugins"
  cd "$HOME/.oh-my-zsh/custom/"

  ZSH_CUSTOM_PLUGINS_PATH=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins

  if [ ! -d "$ZSH_CUSTOM_PLUGINS_PATH/H-S-MW" ]; then
    print_debug "installing oh-my-zsh H-S-MW plugin"
    git clone https://github.com/z-shell/H-S-MW "$ZSH_CUSTOM_PLUGINS_PATH/H-S-MW"
  fi

  if [ ! -d "$ZSH_CUSTOM_PLUGINS_PATH/zsh-autosuggestions" ]; then
    print_debug "installing oh-my-zsh zsh-autosuggestions plugin"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_PLUGINS_PATH/zsh-autosuggestions"
  fi

  if [ ! -d "$ZSH_CUSTOM_PLUGINS_PATH/zsh-syntax-highlighting" ]; then
    print_debug "installing oh-my-zsh zsh-syntax-highlighting plugin"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_PLUGINS_PATH/zsh-syntax-highlighting"
  fi

  # switch to zsh default shell (only when it is not already)
  zsh_path=$(command -v zsh || true)
  current_shell=$(getent passwd "$(whoami)" | cut -d: -f7)
  if [ -z "$zsh_path" ]; then
    print_error "zsh not found, not changing default shell"
  elif [ "$current_shell" = "$zsh_path" ]; then
    print_noop "default shell is already $zsh_path"
  else
    print_info "switch to zsh..."
    sudo usermod --shell "$zsh_path" "$(whoami)"
  fi
}

install_yay() {
  print_info "installing yay..."

  if [ -x "$(command -v yay)" ]; then
    print_info "found yay at: $(command -v yay), skipping install"
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
    neofetch
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

  print_info "installing packages..."
  yay -S --needed --noconfirm "${packages[@]}"

  print_info "installing AUR packages..."
  yay -S --needed --noconfirm "${aur_packages[@]}"
}

install_neovim_plugins() {
  print_info "installing neovim plugins..."
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
  else
    print_info "installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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

# Preserving initial argument
set -- `getopt -l help h $@`
while [ $1 != -- ]
do
  case $1 in
  -h|--help)
    shift
    usage
    exit 0
    ;;
  esac
done
shift # removing '--'

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
      defaults write -g ApplePressAndHoldEnabled -bool false
      ;;
  esac
}

install_all() {
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

if [[ -n $command ]]; then
  case "$command" in
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

# vim: sts=2 sw=2 et
