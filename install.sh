#!/usr/bin/env bash

# TODO Install
#  * jtheoof.zsh-theme
#  * Google Chrome
#  * Fonts (especially Windows into /usr/share/fonts/truetype/windows)

declare -a commands
commands=(packages dotfiles)

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
  echo " jtheoof COMMAND"
  echo
  echo "Commands"
  echo
  echo "  packages              Install common packages"
  echo "  dotfiles              Symlink dotfiles to $HOME"
  echo
}

in_array() {
  local e
  for e in "${@:2}"; do [[ $e == $1 ]] && return 0; done
  return 1
}

link() {
  local l
  if [ -n "$2" ]; then
    l=$2
  else
    l=$HOME/$1
  fi
  print_info "linking: $l"
  if [ -d $l ]; then
    if [ ! -h $l ]; then # not a symlink, we should remove the directory
      print_info "$l is a directory"
      case "$OSTYPE" in
        darwin*)
          rm -ri $l
          ;;
        *)
          rm -rI $l
          ;;
      esac
    fi
  fi
  if $FORCE_MODE ; then
    print_info "forcing symlink $l"
    ln -sf $FILESPATH/$1 $l
    return
  fi
  if [ ! -h $l ]; then # not a symlink, we should make it one
    ln -is $FILESPATH/$1 $l
    if [ -h $l ]; then # checking user response after previous question
      print_success "$l has been symlinked"
    fi
  else
    print_noop "$l already a symlink"
  fi
}

# }}}
# Installers {{{

install_dotfiles() {
  print_info "installing symlinks"

  local exclude
  exclude=(.git .gitattributes .gitignore .config .oh-my-zsh)

  for i in $FILESPATH/.[a-zA-Z]*; do
    in_array $(basename $i) "${exclude[@]}" || link $(basename $i)
  done

  # .config directories
  case "$OSTYPE" in
    *)
      config_dirs="fontconfig htop termite transmission tranmission-remote-cli sway"
      for i in $config_dirs; do
        link ".config/$i"
      done

      link ".local/bin"
      ;;
  esac
}

install_oh_my_zsh() {
  echo "installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  cd $HOME/.oh-my-zsh/custom/

  ln -s $FILESPATH/.oh-my-zsh/custom/themes/sindresorhus.zsh-theme
  ln -s $FILESPATH/.oh-my-zsh/custom/themes/async.zsh
}

install_packages_darwin() {
  print_info "installing homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  brew_packages="\
    ack \
    cloc \
    ctags \
    fswatch \
    git \
    multimarkdown \
    node \
    openssl \
    python \
    readline \
    rename \
    the_silver_searcher \
    tig \
    tmux \
    tree \
    vim \
    wget \
    watch \
    zsh \
  "

  echo "installing brew packages..."
  brew install $brew_packages

  cask_packages="\
    alfred \
    atom \
    dropbox \
    flux \
    google-chrome \
    iterm2 \
    macvim \
    messenger \
    slack \
    spectacle \
    spotify \
    visual-studio-code \
  "

  echo "installing brew cask packages..."
  brew cask install $cask_packages
}

install_packages_linux() {
  packages="\
    ack \
    autoconf \
    base-devel \
    chromium \
    cmake \
    colordiff \
    ctags
    curl \
    gcolor2 \
    geary \
    gimp \
    git \
    gnome-tweak-tool \
    gvim \
    inkscape \
    mercurial \
    nodejs \
    openssh \
    perl-rename \
    python \
    ruby \
    rubygems \
    subversion \
    tig \
    tmux \
    tree \
    vlc \
    wget \
    xclip \
    xsel \
    zsh"

  echo "installing packages..."
  sudo pacman -S --needed $packages
}

install_vim_bundles() {
  vim -c ":BundleInstall" -c ":qa!"
}

# }}}
# Global variables {{{

FILESPATH=$HOME/.dotfiles

# }}}
# Getting options {{{

# Preserving initial argument
MODE=$1
FORCE_MODE=false
set -- `getopt -l help fh $@`
while [ $1 != -- ]
do
  case $1 in
  -h|--help)
    shift
    usage
    exit 0
    ;;
  -f)
    shift
    FORCE_MODE=true
    ;;
  esac
done
shift # removing '--'

# }}}

install_packages() {
  case "$OSTYPE" in
    darwin*)
      install_packages_darwin

      # Turn off the character accent selector and re-enable key repetition.
      defaults write -g ApplePressAndHoldEnabled -bool false
      ;;
    *)
      install_packages_linux
      ;;
  esac
}

install_all() {
  if [ ! -d $FILESPATH ]; then
    cd $HOME
    git clone --recursive https://github.com/jtheoof/dotfiles .dotfiles
    cd $FILESPATH
  fi
  install_packages
  install_dotfiles
  install_oh_my_zsh
  install_vim_bundles
}

if [[ -n $command ]]; then
  case "$command" in
    packages)
      install_packages
      ;;
    dotfiles)
      install_dotfiles
      ;;
  esac
else
  install_all
fi

# vim: sts=2 sw=2 et
