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
ZSH_THEME=""

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker npm H-S-MW z zsh-autosuggestions zsh-syntax-highlighting dotenv)

if [[ `uname` == 'Darwin' ]]; then
    plugins=($plugins macos)
fi

source $ZSH/oh-my-zsh.sh

setopt menu_complete

# 1}}}
# Bindings {{{1

bindkey "^H" backward-delete-word
bindkey "^[[3;5~" delete-word
bindkey "^[[1;5H" beginning-of-line
bindkey "^[[1;5F" end-of-line

# 1}}}
# Exports {{{

export LESS=-FRSX

# }}}
# Aliases {{{1

# Admin
alias lgroups='cat /etc/passwd | cut -d: -f1'

# Docker
alias dm='docker-machine'

# Editing
alias n='nvim'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias diff='colordiff -u'

# Listing
alias rpwd='readlink -f $PWD'

case "$OSTYPE" in
  darwin*)
    alias ll='ls -lah -G'
    alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew'
  ;;
  linux*)
    alias ll='ls -lah --color=always'
  ;;
esac
alias l='ll'
alias lsf='find . -nowarn -type f -maxdepth 1'

alias h='history'
alias hs='history'
alias hsa='history | rg'
alias hsl='history | less'

# Search
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias sgrep='grep --color=auto -inIEr'

alias fa='find . | rg '
alias ff='find . -type f | rg'
alias fd='find . -type d | rg'
alias fl='find . -type l | rg'

# Usage
alias du0='du --max-depth 0 -h .'
alias du1='du --max-depth 1 -h .'
alias ducks='du -cks * | sort -rn | head -11'
alias psa='ps -ef | rg'

# Network
alias ipwan='wget -q -O - checkip.dyndns.org | sed -e "s/.*Current IP Address: //" -e "s/<.*$//"'

# Navigation
alias r='ranger'
alias view='eog'
alias cdg='cd $(git rev-parse --show-toplevel)'
alias cdt='cd `mktemp -d`'

# Programming
alias t='tig'
alias tm='tmux'
alias tmn='tmux new'

# npm
alias ncub='ncu -m bower'

# git
alias lg='lazygit'

# 1}}}
# Functions {{{1

# Compression
function ctar() {
    tar czf $1.tar.gz $1
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

# Hex to Dec
function h2d() {
  echo "ibase=16; $(echo $@ | tr '[:lower:]' '[:upper:]')" | bc
}

# Dec to Hex
function d2h() {
  echo "obase=16; $@" | bc
}

function chpwd() {
    emulate -L zsh
    ls -a
}

function strip-color {
    perl -pe 's/\e\[?.*?[\@-~]//g'
}

# 1}}}
# Misc {{{

# Dircolors
if [[ -f /usr/bin/dircolors && -f $HOME/.dir_colors ]]; then
    eval $(dircolors -b $HOME/.dir_colors)
fi

if [[ `uname` == 'Darwin' ]]; then
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
fi

if [[ -s $HOME/.tmuxinator/scripts/tmuxinator ]]; then
    source $HOME/.tmuxinator/scripts/tmuxinator
fi

# Sourcing zshrc_work if exists
if [[ -s $HOME/.zshrc_work ]]; then
    source $HOME/.zshrc_work
fi

# }}}
# Prompt {{{1

PURE_PROMPT_SYMBOL='»'
PURE_GIT_DOWN_ARROW='↓'
PURE_GIT_UP_ARROW='↑'

autoload -U promptinit; promptinit

prompt pure

# }}}

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
