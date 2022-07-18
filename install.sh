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
  echo $1
  exit ${2:-1}
}

usage() {
  echo "Usage"
  echo
  echo "Installs basic tooling for new machine setup"
  echo
  echo "Supports"
  echo
  echo "  macOS"
  echo "  Arch Linux"
  echo
}

link() {
  ln -nsf $1 $2
}

# }}}
# Installers {{{

install_dotfiles() {
  local dotfiles

  print_info "installing dotfiles and folders"

  dotfiles=$(find $FILESPATH -maxdepth 1 -type f \( -iname '.*' ! -iname '.gitattributes' ! -iname '.gitignore' \))
  for i in $dotfiles; do
    link $i $HOME
  done

  # Link .vim directory
  link $FILESPATH/.vim $HOME

  [ -d $CONFIG_DIR ] || mkdir -p $CONFIG_DIR
  # .config directories
  case "$OSTYPE" in
    *)
      config_dirs=$(ls -d $FILESPATH/.config/*)

      for i in $config_dirs; do
        link $i $CONFIG_DIR
      done

      ;;
  esac

   # .local directories
   [ -d $HOME/.local ] || mkdir -p $HOME/.local
   link $FILESPATH/.local/bin $HOME/.local
}

install_oh_my_zsh() {
  print_info "installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended --keep-zshrc

  print_info "installing oh-my-zsh plugins"
  cd $HOME/.oh-my-zsh/custom/

  ZSH_CUSTOM_PLUGINS_PATH=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins

  if [ ! -d $ZSH_CUSTOM_PLUGINS_PATH/H-S-MW ]; then
    print_debug "installing oh-my-zsh H-S-MW plugin"
    git clone https://github.com/z-shell/H-S-MW $ZSH_CUSTOM_PLUGINS_PATH/H-S-MW
  fi

  if [ ! -d $ZSH_CUSTOM_PLUGINS_PATH/zsh-autosuggestions ]; then
    print_debug "installing oh-my-zsh zsh-autosuggestions plugin"
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM_PLUGINS_PATH/zsh-autosuggestions
  fi

  if [ ! -d $ZSH_CUSTOM_PLUGINS_PATH/zsh-syntax-highlighting ]; then
    print_debug "installing oh-my-zsh zsh-syntax-highlighting plugin"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM_PLUGINS_PATH/zsh-syntax-highlighting
  fi

  # switch to zsh default shell
  print_info "switch to zsh..."
  sudo usermod --shell /usr/bin/zsh $(whoami)
}

install_packages_darwin() {
  print_info "installing homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  brew_packages="\
    asciidoc \
    bash \
    certbot \
    clang-format \
    cloc \
    colordiff \
    ctags \
    ctop \
    curl \
    direnv \
    docker \
    docker-compose \
    dos2unix \
    doxygen \
    freetype \
    fswatch \
    git \
    graphicsmagick \
    grep \
    htop \
    httpie \
    jpeg \
    jq \
    kubernetes-cli \
    kubernetes-helm \
    lazygit \
    md5deep \
    mtr \
    multimarkdown \
    ncdu \
    neofetch \
    neovim \
    ninja \
    nmap \
    node \
    nvm \
    openconnect \
    openssh \
    openvpn \
    optipng \
    pcre \
    perl \
    pidof \
    pkg-config \
    pngquant \
    pure \
    pyenv \
    python \
    python3 \
    ranger \
    readline \
    rename \
    ripgrep \
    rsync \
    snappy \
    ssh-copy-id \
    terminal-notifier \
    tig \
    tldr \
    tmux \
    trash \
    tree \
    vim \
    watch \
    watchman \
    webp \
    wget \
    yarn \
    zsh \
  "

brew_cask_packages="\
    1password \
    1password-ci \
    alfred \
    appcleaner \
    dropbox \
    google-chrome \
    iterm2 \
    macvim \
    rectangle \
    slack \
    spotify \
    visual-studio-code \
  "

  print_info "installing brew packages..."
  brew install $brew_packages

  print_info "installing brew cask packages..."
  brew install --cask $brew_cask_packages
}

install_yay() {
  print_info "installing yay..."
  cd $(mktemp -d)
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -sif --noconfirm
  cd $FILESPATH
}

install_packages_linux() {
  local install_command=""

  packages="\
    alacritty \
    bash \
    bat \
    binutils \
    colordiff \
    coreutils \
    cscope \
    curl \
    diffutils \
    docker \
    git \
    gnupg \
    grep \
    gzip \
    htop \
    httpie \
    imagemagick \
    jq \
    lazygit \
    less \
    lsof \
    make \
    neofetch \
    neovim \
    nodejs \
    npm \
    ripgrep \
    scdoc \
    sed \
    tig \
    tmux \
    tree \
    unzip \
    vim \
    wget \
    zsh \
  "

  aur_packages="\
    zsh-pure-prompt \
  "

  case "$1" in
    arch | manjaro)
      install_command="yay -S --needed --noconfirm"
      ;;
    pop)
      install_command="sudo apt install"
      ;;
    *)
      die "install command is unkown for that OS"
      ;;
  esac

  print_info "installing packages..."
  $install_command $packages

  case "$1" in
    arch | manjaro)
      print_info "installing AUR packages..."
      $install_command $aur_packages
      ;;
  esac
}

install_vim_bundles() {
  if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  fi
  vim -c ":BundleInstall" -c ":qa!"
}

install_plist_launchd_darwin() {
  mkdir -p ~/Library/LaunchAgents

  ln -sf $FILESPATH/launchd/me.jtheoof.launched.brew_update.plist ~/Library/LaunchAgents/

  launchctl load -w ~/Library/LaunchAgents/me.jtheoof.launched.brew_update.plist
}

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
    darwin*)
      install_packages_darwin
      install_plist_launchd_darwin

      # Turn off the character accent selector and re-enable key repetition.
      defaults write -g ApplePressAndHoldEnabled -bool false
      ;;
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
          install_packages_linux $OS_ID
          ;;
        pop)
          install_packages_linux $OS_ID
          ;;
        *)
          die "OS with ID: $OS_ID is not supported"
          ;;
      esac

      ;;
  esac
}

install_all() {
  if [ ! -d $FILESPATH ]; then
    cd $HOME
    git clone --recursive https://github.com/jtheoof/dotfiles $FILESPATH
    cd $FILESPATH
  fi
  install_platform
  install_dotfiles
  install_vim_bundles
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
