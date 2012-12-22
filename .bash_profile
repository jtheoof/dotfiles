if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi
if [ -f "$HOME/.dircolors" ]; then
    eval $(dircolors -b $HOME/.dircolors)
fi

export PATH=$PATH:~/.local/bin:~/dev/android/android-sdk-linux/tools:~/dev/android/android-sdk-linux/platform-tools
