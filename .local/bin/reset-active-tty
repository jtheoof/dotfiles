#!/bin/sh
if [ -z "${ALACRITTY_LOG}" ]; then exit 1; fi

TERM_PID="${ALACRITTY_LOG//[^0-9]/}"
tty=$(ps o tty= --ppid $TERM_PID)

echo -e "\ec" > /dev/$tty
