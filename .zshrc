# .zshrc
#
# From /etc/zsh/zshrc:
#
# This file is sourced only for interactive shells. It should contain commands
# to set up aliases, functions, options, key bindings, etc.
#
# Local Order: .zshenv, .zprofile, .zshrc, .zlogin

# Options {{{1

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="jtheoof"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=30

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting
# for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*).
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git tmux)

source $ZSH/oh-my-zsh.sh

# 1}}}
# Aliases {{{1

# Admin
alias lgroups='cat /etc/passwd | cut -d: -f1'

# Editing
alias v='vim'
alias vi='vim'
alias gv='gvim'
alias sub='sublime'
alias diff='colordiff -u'

# Listing
alias rpwd='readlink -f $PWD'

alias ls='ls --color=auto'
alias lsf='find . -nowarn -type f -maxdepth 1'
alias ll='ls -lah --group-directories-first'
alias l='ll'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'

alias h='history'
alias hs='history'
alias ha='history | ack'
alias hl='history | less'

# Search
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias sgrep='grep --color=auto -inIEr'

alias fa='find . | ack '
alias ff='find . -type f | ack'
alias fd='find . -type d | ack'

# Usage
alias du0='du --max-depth 0 -h .'
alias du1='du --max-depth 1 -h .'
alias ducks='du -cks * | sort -rn | head -11'
alias psa='ps -ef | ack'

# Network
alias ipwan='wget -q -O - checkip.dyndns.org | sed -e "s/.*Current IP Address: //" -e "s/<.*$//"'

# Navigation
alias n='nautilus'
alias n.='nautilus .'
alias view='eog'
alias cdg='cd $(git rev-parse --show-toplevel)'

# Programming
alias t='tig'
alias tm='tmux'

# 1}}}
# Functions {{{1

function man() {
    /usr/bin/man $* | col -bp | iconv -c | \
        vim -c 'map <silent> q :qa!<CR>' \
            -c 'set ft=man nomod nolist nonu noma' -
}

# Compression
function ctar() {
    tar czf $1.tar.gz $1
}

# Track experimental
function TE {
    ln -sf /etc/apt/experimental.list /etc/apt/sources.list
    echo 'Tracking experimental repo'
    echo 'Updating...'
    sleep 2
    apt-get update
}

# Track unstable
function TU {
    ln -sf /etc/apt/unstable.list /etc/apt/sources.list
    echo 'Tracking unstable repo'
    echo 'Updating...'
    sleep 2
    apt-get update
}

# Track testing
function TT {
    ln -sf /etc/apt/testing.list /etc/apt/sources.list
    echo 'Tracking testing repo'
    echo 'Updating...'
    sleep 2
    apt-get update
}

# Make a backup copy w/ date-time appended
function bak {
    cp $1 $1_`date +%H:%M:%S_%m-%d-%Y`
}

function byte {
    TotalBytes=0
    for Bytes in $(ls -l | grep "^-" | awk '{ print $5 }')
    do
        let TotalBytes=$TotalBytes+$Bytes
    done
    TotalMeg=$(echo -e "scale=3 \n$TotalBytes/1048576 \nquit" | bc)
    echo -n "$TotalMeg"
}

# Hold a package
function hold {
    echo "$1 hold" | dpkg --set-selections
}

# Unhold package
function unhold {
    echo "$1 install" | dpkg --set-selections
}

# What packages are held
function held {
    dpkg --get-selections | grep hold
}

# Hex to Dec
function h2d() {
  echo "ibase=16; $(echo $@ | tr '[:lower:]' '[:upper:]')" | bc
}

# Dec to Hex
function d2h() {
  echo "obase=16; $@" | bc
}

function apt-history() {
      case "$1" in
        install)
              cat /var/log/dpkg.log | grep 'install '
              ;;
        upgrade|remove)
              cat /var/log/dpkg.log | grep $1
              ;;
        rollback)
              cat /var/log/dpkg.log | grep upgrade | \
                  grep "$2" -A10000000 | \
                  grep "$3" -B10000000 | \
                  awk '{print $4"="$5}'
              ;;
        *)
              cat /var/log/dpkg.log
              ;;
      esac
}

function chpwd() {
    emulate -L zsh
    ls -a --group-directories-first
}

# 1}}}
# Misc {{{

# Force 256 color terminal on gnome-terminal
if [[ $TERM = "xterm" && $COLORTERM =~ "^gnome" ]]; then
    export TERM="xterm-256color"
fi

# Dircolors
if [[ -f /usr/bin/dircolors && -f $HOME/.dir_colors ]]; then
    eval $(dircolors -b $HOME/.dir_colors)
fi

# Force LESS variable
export LESS=-FRSX

if [[ -s $HOME/.tmuxinator/scripts/tmuxinator ]]; then
    source $HOME/.tmuxinator/scripts/tmuxinator
fi

# Sourcing zshrc_work if exists
if [[ -s $HOME/.zshrc_work ]]; then
    source $HOME/.zshrc_work
fi
# }}}
