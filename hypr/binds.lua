-- Key Bindings Configuration
-- All keyboard and mouse bindings

-- Application launches
hl.bind("SUPER + T", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("brave-origin"))
hl.bind("SUPER + I", hl.dsp.exec_cmd("brave-origin --incognito"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("code"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("env XDG_CURRENT_DESKTOP=gnome gnome-control-center"))
hl.bind("SUPER + SEMICOLON", hl.dsp.exec_cmd("env -u DISPLAY spotify --enable-wayland-ime"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("discord"))

-- Panel controls (noctalia)
hl.bind("SUPER + R", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind("SUPER + S", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))
hl.bind("SUPER + COMMA", hl.dsp.exec_cmd("noctalia msg settings-toggle"))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"))

-- Window management
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen())

-- Focus movement
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + J", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + K", hl.dsp.focus({ workspace = "-1" }))

-- Move windows
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Move to relative workspace (uses function to calculate target)
hl.bind("SUPER + SHIFT + J", function()
  local current = hl.get_active_workspace().id
  local target = current + 1
  hl.dispatch(hl.dsp.window.move({ workspace = target }))
end)

hl.bind("SUPER + SHIFT + K", function()
  local current = hl.get_active_workspace().id
  local target = current - 1
  hl.dispatch(hl.dsp.window.move({ workspace = target }))
end)

-- Workspace bindings (1-9)
for i = 1, 9 do
  hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Screenshots (saved to ~/Pictures/Screenshots/ and copied to clipboard)
-- Region screenshot
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd([[file="$HOME/Pictures/Screenshots/Screenshot_$(date +%Y%m%d_%H%M%S).png"; mkdir -p "$HOME/Pictures/Screenshots" && grim -g "$(slurp)" "$file" && cat "$file" | wl-copy && notify-send "Screenshot saved & copied" "$file" || notify-send -u critical "Screenshot failed" "Region capture was cancelled or failed"]]))

-- Monitor screenshot (captures focused monitor)
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd([[output=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'); file="$HOME/Pictures/Screenshots/Screenshot_$(date +%Y%m%d_%H%M%S).png"; mkdir -p "$HOME/Pictures/Screenshots" && grim -o "$output" "$file" && cat "$file" | wl-copy && notify-send "Screenshot saved & copied" "$file" || notify-send -u critical "Screenshot failed" "Could not capture $output"]]))

-- Active window screenshot
hl.bind("SUPER + P", hl.dsp.exec_cmd([[geometry=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'); file="$HOME/Pictures/Screenshots/Screenshot_$(date +%Y%m%d_%H%M%S).png"; mkdir -p "$HOME/Pictures/Screenshots" && grim -g "$geometry" "$file" && cat "$file" | wl-copy && notify-send "Screenshot saved & copied" "$file" || notify-send -u critical "Screenshot failed" "Could not capture the active window"]]))

-- Full screenshot to clipboard only (Print key)
hl.bind("PRINT", hl.dsp.exec_cmd([[if grim - | wl-copy; then notify-send "Screenshot copied" "Output copied to clipboard"; else notify-send -u critical "Screenshot failed" "Output capture failed"; fi]]))

-- Mouse bindings
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move to relative workspace via mouse (uses function to calculate target)
hl.bind("SUPER + CTRL + mouse_down", function()
  local current = hl.get_active_workspace().id
  local target = current + 1
  hl.dispatch(hl.dsp.window.move({ workspace = target }))
end)

hl.bind("SUPER + CTRL + mouse_up", function()
  local current = hl.get_active_workspace().id
  local target = current - 1
  hl.dispatch(hl.dsp.window.move({ workspace = target }))
end)

hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

-- Exit
hl.bind("SUPER + M", hl.dsp.exit())
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("hyprshutdown"))
