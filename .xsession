#!/bin/sh

# Load your X Resource defaults, if you have them...
if [ -f $HOME/.Xdefaults ]; then
   xrdb -merge $HOME/.Xdefaults
fi
