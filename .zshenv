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

if [ -f $HOME/.ripgreprc ]; then
  export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
fi

# Java
/usr/libexec/java_home 1>/dev/null 2>&1
if [ $? -eq 0 ]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
fi

# This won't work because it's already set by lib/misc.zsh
# So I have to do it directly in ~/.zshrc which is not very clean.
# See: oh-my-zsh
#export LESS=-FRSX

# Add custom directories to $PATH
typeset -U path
path=(
    ~/.local/bin
    ~/.local/work/bin
    ~/.npm/bin
    ~/.rvm/bin
    ~/.krew/bin
    /usr/local/bin
    $path
)

