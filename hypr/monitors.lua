-- Monitor Configuration
-- Display settings and layouts

-- Default monitor 
hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "auto",
  scale = 1.25,
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "preferred",
  mirror = "eDP-1",
  scale = 1.25,
})
