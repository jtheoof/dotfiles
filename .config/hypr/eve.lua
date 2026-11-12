-- Ctrl + mouse side buttons cycle EVE clients through Nicotine while an
-- EVE client ("EVE - <name>") has focus: Ctrl + forward = `]` (next),
-- Ctrl + back = `[` (previous). Temporary, until a Linux G Hub
-- replacement handles per-app mouse mappings.
--
-- The binds are only enabled while EVE is focused (switched on focus and
-- title changes), so other apps keep Ctrl + back/forward and no per-press
-- check is needed. Buttons, unlike the tilt wheel, aren't throttled by
-- Hyprland's binds:scroll_event_delay.

-- A side-button press usually jiggles the mouse. If that lands in the
-- ~30 ms before Hyprland swaps fullscreen to the newly focused client,
-- follow_mouse = 1 refocuses the old client (still fullscreen under the
-- cursor): the new one shows but stays unfocused at background FPS, and
-- Nicotine still highlights the old one. Only refocus on hover when the
-- cursor crosses into another window. This is global, not EVE-only.
hl.config({ input = { mouse_refocus = false } })

local BTN_SIDE = 275 -- back side button
local BTN_EXTRA = 276 -- forward side button

local function nicotine(direction)
  return function()
    hl.exec_cmd("nicotine " .. direction)
  end
end

local binds = {
  hl.bind("CTRL + mouse:" .. BTN_EXTRA, nicotine("forward")),
  hl.bind("CTRL + mouse:" .. BTN_SIDE, nicotine("backward")),
}

local function is_eve(window)
  -- A window can be briefly title-less while it opens or closes.
  return window ~= nil and (window.title or ""):sub(1, 6) == "EVE - "
end

local enabled = nil
local function sync()
  local want = is_eve(hl.get_active_window())
  if want ~= enabled then
    enabled = want
    for _, bind in ipairs(binds) do
      bind:set_enabled(want)
    end
  end
end

hl.on("window.active", sync)
-- EVE's title only becomes "EVE - <name>" after character selection.
hl.on("window.title", sync)
sync()
