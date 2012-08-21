# Config {{{1
#------------------------------------------------------------------------------
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="doubleend"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh
#------------------------------------------------------------------------------
#1}}}

# Customization {{{1
#------------------------------------------------------------------------------

# Dircolors
[[ -f /usr/bin/dircolors ]] && [[ -f $HOME/.dircolors ]] && eval $(dircolors -b $HOME/.dircolors)

# Exports {{{2
export NODE_PATH=/usr/local/lib/jsctags/:$NODE_PATH
export PATH=/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/.local/bin:$HOME/dev/android/android-sdk-linux/tools:$HOME/dev/android/android-sdk-linux/platform-tools:/opt/SenchaSDKTools-2.0.0-beta3
#2}}}

# Aliases {{{2
# Admin
alias lgroups='cat /etc/passwd | cut -d: -f1'

# Work {{{3
alias rsync-root='cd /home/jeremy; rsync -avz .ackrc .dircolors .gitconfig .oh-my-zsh .toprc .vim .vimrc .zshrc /root'
alias rsync-jenkins='sudo su -c "rsync -avz --delete --exclude .svn --exclude build --exclude applications --exclude poc --exclude pocs --exclude documents /home/jeremy/dev/bt/galak/* ~/jobs/alwa/workspace/" - jenkins'
alias rsync-iad="rsync -av -C --exclude ssi --exclude cgi-bin deliver/6.9.44-20120717/GW-IHM-3965b-6.9.x/* iad/"
alias node-jslint="node $HOME/dev/me/node-jslint/bin/jslint.js --maxerr 500 --nomen --plusplus --regexp --sloppy --undef --white"
alias svn-df='svn diff | colordiff'
alias mount-nfs='mount -t nfs -o nolock 192.168.2.2:/root/dev/bt/bewan/iad /etc/bewan/iad'
#3}}}

# Editing {{{3
alias vi='vim'
alias gv='gvim'
alias diff='colordiff'
#3}}}

# Listing {{{3
alias ls='ls --color=auto'
alias lsf='find . -nowarn -type f -maxdepth 1'
alias ll='ls -lah --group-directories-first'
alias l='ll'
alias lm='ll|more'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'

alias h='history'
alias hl='history | less'
#3}}}

# Search {{{3
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias sgrep='grep --color=auto -inIEr'

alias ack='ack-grep'

alias ff='find . -type f -name'
alias fd='find . -type d -name'
alias f.='find . -name'
#3}}}

# Usage {{{3
alias du0='du --max-depth 0 -h .'
alias du1='du --max-depth 1 -h .'
alias ducks='du -cks * | sort -rn | head -11'
alias psa='ps -ef | ack'
#3}}}

# Navigation {{{3
alias n.='nautilus .'
#3}}}

# APT {{{3
alias  ACD='apt-cache depends' # show dependencies of <package>.deb
alias  ACS='apt-cache search' # search for string
alias  ACS='apt-cache show' # show details about packages
alias  AGA='sudo apt-get autoremove' # remove packages no longer needed
alias  AGB='sudo apt-get build-dep' # install dependencies for source built packages using deb-src
alias  AGC='sudo apt-get clean' # clear out downloaded .debs from /var/cache/apt/archives
alias  AGDU='sudo apt-get dist-upgrade' # apply available upgrades 
alias  AGG='sudo apt-get upgrade' # apply available upgrades
alias  AGI='sudo apt-get install' # install package(s) from a Debian repository.
alias  AGIR='sudo apt-get install --reinstall' # reinstall package
alias  AGR='sudo apt-get remove' # remove package, leave config files
alias  AGS='apt-get source' # download Debian source to $PWD - requires deb-src enabled in sources.list 
alias  AGU='sudo apt-get update' # update the list of available packages
alias  AH='apt-history' # not native to sudo apt-get - apt-history function required
alias  ASV='apt-show-versions' # not native to sudo apt-get - apt-show-versions required
alias  ASVE='apt-show-versions | grep /experimental' # list all packages from /experimental
alias  ASVS='apt-show-versions | grep /stable' # list all packages from /stable
alias  ASVT='apt-show-versions | grep /testing' # list all packages from /testing
alias  ASVU='apt-show-versions | grep /unstable' # list all packages from /unstable
#3}}}

# DPKG {{{3
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
#3}}}
#2}}}

# Functions {{{2
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
    echo "$1 hold"|dpkg --set-selections 
}

# Unhold package 
function unhold {
    echo "$1 install" |dpkg --set-selections
}

# What packages are held
function held {
    dpkg --get-selections | grep hold
}

# Hex to Dec
function h2d() {
  echo "ibase=16; $(echo $@ | tr '[:lower:]' '[:upper:]')"|bc
}

# Dec to Hex
function d2h() {
  echo "obase=16; $@"|bc
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
#2}}}
#1}}}
