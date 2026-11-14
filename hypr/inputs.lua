-- Input Configuration
-- Keyboard, mouse, and touchpad settings

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "ctrl:nocaps",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,

    touchpad = {
      natural_scroll = true,
      disable_while_typing = true,
    },
  },
})

-- Gestures
hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})
