# .zshenv
#
# From /etc/zsh/zshenv:
#
# This file is sourced on all invocations of the shell.  If the -f flag is
# present or if the NO_RCS option is set within this file, all other
# initialization files are skipped.
#
# This file should contain commands to set the command search path, plus other
# important environment variables.  This file should not contain commands that
# produce output or assume the shell is attached to a tty.
#
# Local Order: .zshenv, .zprofile, .zshrc, .zlogin

export EDITOR=vim

# This won't work because it's already set by lib/misc.zsh
# See: oh-my-zsh
export LESS=-FRSX

if [[ ! -z "$PATH" ]] then
    PATH=/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/sbin:/sbin:$PATH
    PATH=$HOME/.local/bin:$PATH

    # Set android SDK and NDK PATH
    if [[ -d $HOME/dev/android ]] then
        PATH=$HOME/dev/android/sdk/tools:$PATH
        PATH=$HOME/dev/android/sdk/platform-tools:$PATH
        PATH=$HOME/dev/android/ndk:$PATH
    fi
fi

if [[ -d /usr/lib/jvm/java-6-openjdk ]] then
    export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
fi

if [[ -d /opt/teamcity/data ]] then
    export TEAMCITY_DATA_PATH=/opt/teamcity/data
fi
