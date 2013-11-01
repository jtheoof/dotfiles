#!/bin/sh
# vim:set et ts=2 sw=2:

# TODO Install
#  * jtheoof.zsh-theme
#  * Google Chrome
#  * Fonts (especially Windows into /usr/share/fonts/truetype/windows)

# Print functions {{{

print_debug() {
  echo "$1"
}

print_info() {
  echo "\033[33m$1\033[0m"
}

print_noop() {
  echo "\033[35m$1\033[0m"
}

print_success() {
  echo "\033[32m$1\033[0m"
}

print_error() {
  echo "\033[31m$1\033[0m"
}

# }}}
# Utils {{{

get_github_repos() {
  git clone -q https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
}

# }}}
# Handlers {{{

link() {
    l=$HOME/$1
    print_debug "linking: $l"
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

handle_install_dotfiles() {
  print_info "installing symlinks"
  for i in $FILESPATH/.*rc; do
    link $(basename $i)
  done

  for i in $FILESPATH/.z*; do
    link $(basename $i)
  done

  for i in $FILESPATH/.*conf; do
    link $(basename $i)
  done

  for i in $FILESPATH/.X*; do
    link $(basename $i)
  done

  for i in $FILESPATH/.x*; do
    link $(basename $i)
  done

  home_dirs=".cgdb .dircolors .gitconfig .tilda .tmuxinator .vim"
  for i in $home_dirs; do
    link "$i"
  done

  if [ ! -d $HOME/.oh-my-zsh ]; then
    print_info "Cloning oh-my-zsh"
    git clone https://github.com/robyrussel/oh-my-zsh $HOME/.oh-my-zsh
  else
    print_info "oh-my-zsh found, skipping..."
  fi

  # .config directories
  config_dirs="htop sublime-text-2 terminator"
  for i in $config_dirs; do
    link ".config/$i"
  done

  link ".local/bin"

  exit 0
}

handle_install_npm_packages() {
  packages="\
    esprima \
    jsonlint \
    jsonlint \
    less"

  for p in $packages; do
    print_info "installing node package: $p"
    sudo npm install $p -g
  done
}

handle_install_packages() {
  packages="\
    ack-grep \
    activity-log-manager \
    ant \
    autoconf \
    build-essential \
    colordiff
    compiz-plugins-extra
    compizconfig-settings-manager \
    curl \
    exuberant-ctags
    gcolor2 \
    gconf-editor \
    gimp \
    git \
    gnome-tweak-tool \
    google-chrome-stable \
    mercurial \
    ncurses-term \
    nodejs \
    npm \
    pidgin \
    python \
    ruby \
    rubygems \
    spotify-client \
    subversion \
    synapse \
    terminator \
    tidy \
    tig \
    tilda \
    tmux \
    tree \
    vim-gnome \
    vlc \
    xsel \
    zeitgeist \
    zsh"

  for p in $packages; do
    print_info "installing package: $p"
    sudo apt-get install -qy $p
  done
}

handle_install() {
  shift
  case "$1" in
    dotfiles)
      handle_install_dotfiles
      get_github_repos
      ;;
    packages)
      handle_install_packages
      ;;
    npm)
      handle_install_npm_packages
      ;;
  esac
}

# Monokai palette colors
handle_terminal_colors() {
  shift
  gconftool-2 --set "/apps/gnome-terminal/profiles/Profile0/use_theme_colors" --type bool false
  gconftool-2 --set "/apps/gnome-terminal/profiles/Profile0/background_color" --type string "#272728282222"
  gconftool-2 --set "/apps/gnome-terminal/profiles/Profile0/foreground_color" --type string "#F8F8F8F8F2F2"
#                                                                                   0:Black      :1:Red        :2:Green      :3:Yellow     :4:Blue       :5:Magenta    :6:Cyan       :7:White       :8:DarkGrey   :9:LightRed   :10:LightGreen:11:LightYello:12:LightBlue :13:LightMagen:14:LightCyan :15:LightWhite
  gconftool-2 --set "/apps/gnome-terminal/profiles/Profile0/palette" --type string "#272728282222:#E2E230302E2E:#A6A6E2E22E2E:#FDFD97971F1F:#32328585D2D2:#F9F926267272:#6666D9D9EFEF:#F8F8F8F8F2F2:#3E3E3D3D3232:#FFFF36363434:#BCBCFFFF3434:#E6E6DBDB7474:#3D3DA1A1FFFF:#FFFF41418585:#6D6DE8E8FFFF:#F8F8F8F8F2F2"
  gconftool-2 --set "/apps/gnome-terminal/profiles/Profile0/scrollback_lines" --type int 5000
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

handle_conf() {
  shift
  case "$1" in
    load)
      print_info "loading: $FILESPATH/conf/$2.xml"
      gconftool-2 --load $FILESPATH/conf/$2.xml
      ;;
    dump)
      print_info "dumping: $FILESPATH/conf/$2.xml"
      gconftool-2 --dump /apps/$2 > $FILESPATH/conf/$2.xml
      ;;
    *)
      print_error "usage: conf [dump] [load] appname"
  esac
}

handle_terminal() {
  shift
  case "$1" in
    colors)
      handle_terminal_colors "$@" ;;
    *)
      print_error "unknown option $1" ;;
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
print_info "git root folder found at: $GITPATH"
FILESPATH=$GITPATH

# }}}
# Getting options {{{

# Preserving initial argument
MODE=$1
FORCE_MODE=false
set -- `getopt f $@`
while [ $1 != -- ]
do
  case $1 in
  -f)
    FORCE_MODE=true ;;
  esac
  shift # next flag
done
shift # removing '--'

# }}}

case "$1" in

  # Unable to shift before calling function
  # because of shell limitations.

  install)
    handle_install "$@" ;;

  dconf)
    handle_dconf "$@" ;;

  conf)
    handle_conf "$@" ;;

  terminal|term)
    handle_terminal "$@" ;;

  vim)
    handle_vim "$@" ;;

  '') echo "Usage: `basename "$0"` <command> [options]" ;;

  *) echo "`basename "$0"` $basename: unknown command." >&2; exit 1 ;;
esac