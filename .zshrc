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
# DISABLE_AUTO_TITLE="true"

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
plugins=(git)

source $ZSH/oh-my-zsh.sh

# 1}}}
# Aliases {{{1

# General {{{2

# Admin
alias lgroups='cat /etc/passwd | cut -d: -f1'

# Editing
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
alias lm='ll|more'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'

alias h='history'
alias hs='history'
alias hf='history | ack'
alias hl='history | less'

# Search
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias sgrep='grep --color=auto -inIEr'

alias ack='ack-grep --color-match="bold magenta"'

alias ff='find . -type f -name'
alias fd='find . -type d -name'
alias f.='find . -name'

# Usage
alias du0='du --max-depth 0 -h .'
alias du1='du --max-depth 1 -h .'
alias ducks='du -cks * | sort -rn | head -11'
alias psa='ps -ef | ack'

# Network
alias ipwan='wget -q -O - checkip.dyndns.org | sed -e "s/.*Current IP Address: //" -e "s/<.*$//"'

# Navigation
alias n.='nautilus .'

# 2}}}
# APT {{{2

alias  acd='apt-cache depends' # show dependencies of <package>.deb
alias  acs='apt-cache search' # search for string
alias  aga='sudo apt-get autoremove' # remove packages no longer needed
alias  agb='sudo apt-get build-dep' # install dependencies for source built packages using deb-src
alias  agc='sudo apt-get clean' # clear out downloaded .debs from /var/cache/apt/archives
alias  agdu='sudo apt-get dist-upgrade' # apply available upgrades
alias  agg='sudo apt-get upgrade' # apply available upgrades
alias  agi='sudo apt-get install' # install package(s) from a Debian repository.
alias  agir='sudo apt-get install --reinstall' # reinstall package
alias  agr='sudo apt-get remove' # remove package, leave config files
alias  ags='apt-get source' # download Debian source to $PWD - requires deb-src enabled in sources.list
alias  agu='sudo apt-get update' # update the list of available packages
alias  ah='apt-history' # not native to sudo apt-get - apt-history function required
alias  asv='apt-show-versions' # not native to sudo apt-get - apt-show-versions required
alias  asve='apt-show-versions | grep /experimental' # list all packages from /experimental
alias  asvs='apt-show-versions | grep /stable' # list all packages from /stable
alias  asvt='apt-show-versions | grep /testing' # list all packages from /testing
alias  asvu='apt-show-versions | grep /unstable' # list all packages from /unstable

# 2}}}
# DPKG {{{2

alias  DL='dpkg -l' # list all installed packages
alias  DF='dpkg -L' # list files installed by <package>
alias  DT='dpkg -L' # list files installed by <package>
alias  DI='dpkg -i' # install <package>.deb
alias  DS='dpkg -l | ack' # list installed packages, search for string
alias  DP='dpkg -p' # show details of package, same as apt-cache show
alias  DC='dpkg -c' # list contents of a .deb package
alias  DCS='dpkg --configure -a' # use then when you fuck up dpkg mid-install or something
alias  DIF='dpkg -i --force-overwrite' # use when you get "trying to overwrite <something> which is also in package <something>"
alias  DR='dpkg-reconfigure' # reconfigure a package that's already installed
alias  DB='dpkg-buildpackage' # build from Debianized source

# 2}}}
# Work {{{2

alias diff-i2s="diff -x .svn -ruN iad IHM-GW/IHM-GW-8.0.0/IHM"
alias diff-s2i="diff -x .svn -ruN IHM-GW/IHM-GW-8.0.0/IHM iad"
alias rsync-root='cd /home/jeremy; rsync -avz .ackrc .dircolors .gitconfig .oh-my-zsh .toprc .vim .vimrc .zshrc /root'
alias rsync-jenkins='sudo su -c "rsync -avz --delete --exclude .svn --exclude build --exclude applications --exclude poc --exclude pocs --exclude documents /home/jeremy/dev/bt/galak/* ~/jobs/alwa/workspace/" - jenkins'
alias rsync-i2s="rsync -avz -C --exclude ssi --exclude cgi-bin --exclude index.cgi iad/ IHM-GW/IHM-GW-8.0.0/IHM"
alias rsync-s2i="rsync -avz -C --exclude ssi --exclude cgi-bin --exclude index.cgi IHM-GW/IHM-GW-8.0.0/IHM/ iad"
alias mount-nfs='mount -t nfs -o nolock 192.168.2.2:/root/dev/bt/bewan/iad /etc/bewan/iad'
alias node-jslint="node $HOME/dev/me/node-jslint/bin/jslint.js --maxerr 500 --nomen --plusplus --regexp --sloppy --undef --white"
alias svn-df='svn diff | colordiff'

# 2}}}

# 1}}}
# Exports {{{1

export LESS=-FRSX
export NODE_PATH=/usr/local/lib/jsctags/:$NODE_PATH
export PATH=/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/.local/bin:$HOME/dev/android/android-sdk-linux/tools:$HOME/dev/android/android-sdk-linux/platform-tools:/opt/SenchaSDKTools-2.0.0-beta3:/opt/eclipse/eclipse-cpp-indigo-SR2-linux-gtk-x86_64-RTC-v4.0

# 1}}}
# Functions {{{1

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
# Bindings {{{

#bindkey -v
#bindkey -M vicmd '?' history-incremental-search-backward
#bindkey '^R' history-incremental-search-backward

# }}}
# Misc {{{

# Dircolors
if [[ -f /usr/bin/dircolors && -f $HOME/.dircolors ]]; then
   eval $(dircolors -b $HOME/.dircolors)
fi

# Sourcing zshrc_work if exists
if [[ -f $HOME/.zshrc_work ]]; then
    source $HOME/.zshrc_work
fi
# }}}
