#!/bin/bash

alias vi='vim'

alias functions='set | grep "()"'

# Listing
alias ls='ls --color=auto'
alias ll='ls -lah --group-directories-first'
alias l='ll'
alias lm='ll|more'
alias dir='ls --color=auto --format=vertical'
alias dirs='ls -d */'
alias vdir='ls --color=auto --format=long'

alias h='history'
alias hl='history | less'

# Search
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias sgrep='grep --color=auto -inIEr'

alias ack='ack-grep'

alias ff='find . -type f -name'
alias fd='find . -type d -name'
alias f.='find . -name'

# Usage
alias ducks='du -cks * | sort -rn | head -11'

# Diff
alias diff='colordiff -u'

# navigation
alias n.='nautilus .'

# APT aliases
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
alias  AVE='apt-show-versions|grep /experimental' #List all packages from /experimental
alias  AVU='apt-show-versions|grep /unstable'
alias  AVT='apt-show-versions|grep /testing'
alias  AVS='apt-show-versions|grep /stable'
alias  AVEC='apt-show-versions|grep -c /experimental' #Display total number of pacakges from /experimental
alias  AVUC='apt-show-versions|grep -c /unstable' 
alias  AVTC='apt-show-versions|grep -c /testing'
alias  AVSC='apt-show-versions|grep -c /stable'

# dpkg aliases
alias  DI='dpkg -i' #Install <package>.deb
alias  DL='dpkg -l|grep' # list installed packages, search for string
alias  DP='dpkg --purge' #Remove package and config files
alias  DC='dpkg -c' #list contents of a .deb package
alias  DCS='dpkg --configure -a' #use then when you fuck up dpkg mid-install or something
alias  DIF='dpkg -i --force-overwrite' #use when you get "trying to overwrite <something> which is also in package <something>"
alias  DR='dpkg-reconfigure' #Reconfigure a package that's already installed
alias  DB='dpkg-buildpackage' #Build from Debianized source

# Functions

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
