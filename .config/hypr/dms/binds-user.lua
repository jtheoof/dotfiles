-- Optional per-user keybind overrides (managed by DMS). Loaded after default binds.

-- Open the terminal with SUPER+Return instead of SUPER+T
hl.unbind("SUPER + T")
hl.bind("SUPER + Return", hl.dsp.exec_cmd("alacritty"))
