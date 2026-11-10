-- Window Rules Configuration
-- Rules for specific windows and applications

-- Suppress maximize events for all windows
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Fix for xwayland drag-and-drop issues
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

-- Keep Steam games running in background
-- Prevents games from pausing when window loses focus
hl.window_rule({
  name = "steam-game-suppress-activate",
  match = { class = "^steam_app_.*$" },
  render_unfocused = true,
  idle_inhibit = "always",
  suppress_event = "activate",
})
