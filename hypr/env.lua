-- Environment Variables Configuration
-- Sets environment variables for Wayland, Qt, GTK, etc.

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Qt configuration
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- GTK configuration
hl.env("GDK_BACKEND", "wayland")

-- Electron apps
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- Mozilla apps
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- NixOS
hl.env("NIXOS_OZONE_WL", "1")

-- Cursor configuration
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
