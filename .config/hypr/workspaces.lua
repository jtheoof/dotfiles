-- Desktops spanning all monitors, like GNOME or Windows virtual desktops.
-- Desktop N is workspace N*10+i on the i-th monitor, so SUPER+N switches
-- every monitor at once. Replaces the per-monitor workspace binds from dms.binds.

local monitors = { "DP-1", "DP-3", "DP-2" } -- left to right
local desktops = 9

for d = 1, desktops do
	for i, name in ipairs(monitors) do
		hl.workspace_rule({
			workspace = tostring(d * 10 + i),
			monitor = name,
			default_name = tostring(d),
			default = d == 1,
			persistent = true,
		})
	end
end

local function monitor_index(name)
	for i, m in ipairs(monitors) do
		if m == name then
			return i
		end
	end
	return 1
end

local function current_desktop()
	local ws = hl.get_active_workspace()
	local d = ws and math.floor(ws.id / 10) or 1
	return math.max(1, math.min(desktops, d))
end

local function go_to_desktop(d)
	local active = hl.get_active_monitor()
	local current = active and monitor_index(active.name) or 1
	local cursor = hl.get_cursor_pos()

	-- Switch the other monitors first and the focused one last, so focus stays put
	for i, name in ipairs(monitors) do
		if i ~= current and hl.get_monitor(name) then
			hl.dispatch(hl.dsp.focus({ workspace = tostring(d * 10 + i) }))
		end
	end
	hl.dispatch(hl.dsp.focus({ workspace = tostring(d * 10 + current) }))

	-- Focusing another monitor warps the cursor there; put it back
	if cursor then
		hl.dispatch(hl.dsp.cursor.move({ x = cursor.x, y = cursor.y }))
	end
end

local function move_to_desktop(d)
	local active = hl.get_active_monitor()
	local i = active and monitor_index(active.name) or 1
	hl.dispatch(hl.dsp.window.move({ workspace = tostring(d * 10 + i), follow = false }))
	go_to_desktop(d)
end

local function step(delta)
	return math.max(1, math.min(desktops, current_desktop() + delta))
end

for d = 1, desktops do
	hl.unbind("SUPER + " .. d)
	hl.unbind("SUPER + SHIFT + " .. d)
	hl.bind("SUPER + " .. d, function()
		go_to_desktop(d)
	end, { description = "Go to desktop " .. d })
	hl.bind("SUPER + SHIFT + " .. d, function()
		move_to_desktop(d)
	end, { description = "Move window to desktop " .. d })
end

for _, keys in ipairs({ { next = "Page_Down", prev = "Page_Up" }, { next = "U", prev = "I" } }) do
	for dir, key in pairs(keys) do
		local delta = dir == "next" and 1 or -1
		hl.unbind("SUPER + " .. key)
		hl.unbind("SUPER + SHIFT + " .. key)
		hl.bind("SUPER + " .. key, function()
			go_to_desktop(step(delta))
		end, { description = (dir == "next" and "Next" or "Previous") .. " desktop" })
		hl.bind("SUPER + SHIFT + " .. key, function()
			move_to_desktop(step(delta))
		end, { description = "Move window to " .. (dir == "next" and "next" or "previous") .. " desktop" })
	end
end

hl.on("hyprland.start", function()
	go_to_desktop(1)
end)
