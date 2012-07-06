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

# Customize to your needs...

# Exports {{{1
#------------------------------------------------------------------------------
export PATH=/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/.local/bin:$HOME/dev/android/android-sdk-linux/tools:$HOME/dev/android/android-sdk-linux/platform-tools:/opt/SenchaSDKTools-2.0.0-beta3
export NODE_PATH=/usr/local/lib/jsctags/:$NODE_PATH
#------------------------------------------------------------------------------
#1}}}

# Aliases {{{1
#------------------------------------------------------------------------------
# Admin
alias lgroups='cat /etc/passwd | cut -d: -f1'

# Work {{{2
alias rsync-root='cd /home/jeremy; rsync -avz .ackrc .dircolors .gitconfig .oh-my-zsh .toprc .vim .vimrc .zshrc /root'
alias rsync-jenkins='sudo su -c "rsync -avz --delete --exclude .svn --exclude build --exclude applications --exclude poc --exclude pocs --exclude documents /home/jeremy/dev/bt/galak/* ~/jobs/alwa/workspace/" - jenkins'
alias node-jslint="node $HOME/dev/me/node-jslint/bin/jslint.js --maxerr 500 --nomen --plusplus --regexp --sloppy --undef --white"
alias svn-df='svn diff | colordiff'
alias mount-nfs='mount -t nfs -o nolock 192.168.1.3:/root/dev/bt/bewan/iad /etc/bewan/iad'
#2}}}

# Editing {{{2
alias vi='vim'
alias gv='gvim'
alias diff='colordiff -u'
#2}}}

# Listing {{{2
alias ls='ls --color=auto'
alias lsf='find . -nowarn -type f -maxdepth 1'
alias ll='ls -lah --group-directories-first'
alias l='ll'
alias lm='ll|more'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'

alias h='history'
alias hl='history | less'
#2}}}

# Search {{{2
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias sgrep='grep --color=auto -inIEr'

alias ack='ack-grep'

alias ff='find . -type f -name'
alias fd='find . -type d -name'
alias f.='find . -name'
#2}}}

# Usage {{{2
alias du0='du --max-depth 0 -h .'
alias du1='du --max-depth 1 -h .'
alias ducks='du -cks * | sort -rn | head -11'
alias psa='ps -ef | ack'
#2}}}

# Navigation {{{2
alias n.='nautilus .'
#2}}}

# apt {{{2
alias  AF='sudo apt-get -f install' #Fix missing or uninstalled packages.
alias  AU='sudo apt-get update' #Update the list of available packages
alias  AUG='sudo apt-get upgrade' #Apply available upgrades
alias  ADU='sudo apt-get dist-upgrade' #Apply available upgrades 
alias  AD='apt-cache depends' #Show dependencies of <package>.deb
alias  AS='apt-cache search' #Search for string
alias  AC='sudo apt-get clean' #Clear out downloaded .debs from /var/cache/apt/archives
alias  AP='apt-cache show' #Show details about packages
alias  AI='sudo apt-get install' #Install package(s) from a Debian repository.
alias  AR='sudo apt-get remove' #Remove package, leave config files
alias  ARP='sudo apt-get remove --purge' #Remove including config files
alias  AIR='sudo apt-get install --reinstall' #Reinstall package
alias  AGA='sudo apt-get autoremove'
alias  AGBD='sudo apt-get build-dep' # install dependencies for source built packages using deb-src
alias  AGS='apt-get source' # download Debian source to $PWD - requires deb-src enabled in sources.list 
alias  AH='apt-history' # not native to sudo apt-get - apt-history function required
alias  AV='apt-show-versions' # not native to sudo apt-get - apt-show-versions required
alias  AVE='apt-show-versions | grep /experimental' #List all packages from /experimental
alias  AVU='apt-show-versions | grep /unstable'
alias  AVT='apt-show-versions | grep /testing'
alias  AVS='apt-show-versions | grep /stable'
alias  AVEC='apt-show-versions | grep -c /experimental' #Display total number of pacakges from /experimental
alias  AVUC='apt-show-versions | grep -c /unstable' 
alias  AVTC='apt-show-versions | grep -c /testing'
alias  AVSC='apt-show-versions | grep -c /stable'
#2}}}

# dpkg {{{2
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
#2}}}
#------------------------------------------------------------------------------
#1}}}

# Functions {{{1
#------------------------------------------------------------------------------
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
    ls -a
}
#------------------------------------------------------------------------------
#1}}}

[[ -f /usr/bin/dircolors ]] && [[ -f $HOME/.dircolors ]] && eval $(dircolors -b $HOME/.dircolors)
