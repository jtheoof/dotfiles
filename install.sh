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

get_github_repos() {
  git clone -q https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
}

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
      rm -rI $l
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
# Handlers {{{

handle_install_dotfiles() {
  print_info "installing symlinks"

  local exclude
  exclude=(.git .gitattributes .gitignore .config .oh-my-zsh)

  for i in $FILESPATH/.[a-zA-Z]*; do
    in_array $(basename $i) "${exclude[@]}" || link $(basename $i)
  done

  if [ ! -d $HOME/.oh-my-zsh ]; then
    print_info "Cloning oh-my-zsh"
    git clone https://github.com/robyrussel/oh-my-zsh $HOME/.oh-my-zsh
  else
    print_info "oh-my-zsh found, skipping..."
  fi

  link $FILESPATH/.oh-my-zsh/custom/themes $HOME/.oh-my-zsh/custom/themes

  # .config directories
  config_dirs="fontconfig htop transmission tranmission-remote-cli"
  for i in $config_dirs; do
    link ".config/$i"
  done

  link ".local/bin"

  exit 0
}

handle_packages_npm() {
  packages="\
    jshint \
    grunt \
    less"

  for p in $packages; do
    print_info "installing node package: $p"
    sudo npm install $p -g
  done
}

handle_packages() {
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
    xsel \
    zsh"

  echo "Installing packages..."
  sudo pacman -S --needed $packages
}

handle_install() {
  shift
  case "$1" in
    dotfiles)
      handle_install_dotfiles
      get_github_repos
      ;;
    packages)
      handle_packages
      ;;
    npm)
      handle_packages_npm
      ;;
  esac
}

handle_dconf() {
  shift
  case "$1" in
    load)
      print_info "loading: $FILESPATH/conf/dconf"
      dconf load / < $FILESPATH/conf/dconf
      ;;
    dump)
      print_info "dumping: $FILESPATH/conf/dconf"
      dconf dump / > $FILESPATH/conf/dconf
      ;;
    *)
      print_error "usage: dconf [dump] [load]"
  esac
}

handle_vim() {
  shift
  case "$1" in
    package)
      case "$2" in
        windows)
          print_info "Creating vim package"
          tmp="/tmp/vim.package"
          dir=$PWD
          bak=$HOME/Dropbox/Backup/Vim
          if [ -d  $tmp ]; then
            rm -rf $tmp
          fi
          mkdir $tmp && cd $tmp
          rsync -q -avz -C --exclude=undodir/ $HOME/.vim/ vimfiles
          cp -rL $HOME/.vimrc _vimrc
          zip -q -r vim-$(date +%Y%m%d).zip vimfiles _vimrc
          if [ ! -d $bak ]; then
            print_error "unable to find $bak"
            cd $dir
            exit 1
          fi
          mv vim-$(date +%Y%m%d).zip $bak
          cd $dir
      esac
  esac
}

# }}}
# Global variables {{{

# Get the path where the file is located.
# Then resolve symbolic link just to make sure.
SCRIPTPATH=$(dirname $(readlink -f ${0}))
cd $SCRIPTPATH
GITPATH=$(git rev-parse --show-toplevel $SCRIPTPATH | head -1)
cd $OLDPWD
if [ ! -d $GITPATH ]; then
    print_error "could not find .git directory, something is fishy"
    exit 1
fi

FILESPATH=$GITPATH

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
# Interactive helpers {{{

interactive_help() {
  echo "This script will guide you after a fresh install of the system."
  echo "I switched from Ubuntu to Arch Linux so a couple of packages and"
  echo "some behaviour might have changed."
  echo "By default, it runs in the interactive mode, but it also can be run"
  echo "non-interactively, just feed it with the necessary options, see"
  echo "'jtheoof --help' for details."
  echo
}

interactive_select_command() {
  echo "Select the command you want to use:"
  select command
  do
    if [[ -z $command ]]
    then
      die "Unkown selection, exiting" 2
    fi
    break
  done
  echo
}

# }}}

interactive_help
interactive_select_command "${commands[@]}"

if [[ -n $command ]]; then
  case "$command" in
    packages)
      handle_packages
      handle_packages_npm
      ;;
    dotfiles)
      handle_install_dotfiles
      ;;
  esac
else
  usage
fi
# vim:sts=2:sw=2:et:
