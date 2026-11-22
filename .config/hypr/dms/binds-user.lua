-- Optional per-user keybind overrides (managed by DMS). Loaded after default binds.

-- Open the terminal with SUPER+Return instead of SUPER+T
hl.unbind("SUPER + T")
hl.bind("SUPER + Return", hl.dsp.exec_cmd("alacritty"))

-- Region screenshot into the swappy editor
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))

-- Region screen recording (toggle) into ~/Videos/Recordings
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.local/bin/screenrec"))

-- Emoji picker (DMS emojiPicker plugin)
hl.bind("SUPER + period", hl.dsp.exec_cmd("dms ipc call emojiPicker toggle"))

-- Screen color picker (replaces the default DPMS toggle)
hl.unbind("SUPER + SHIFT + P")
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("dms color pick -a --hex"))
