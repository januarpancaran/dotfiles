#!/bin/bash

setup_hyprland() {
  echo "Setting up Hyprland compositor..."

  echo "Installing Hyprland packages..."
  if ! install_cmd hyprland hyprland-guiutils hyprland-devel xdg-desktop-portal-hyprland noctalia; then
    echo "Failed to install Hyprland packages"
    return 1
  fi

  echo "Configuring Noctalia screen mirror plugin for Hyprland..."
  if [ -f "$CONF_DIR/noctalia/plugins.toml" ]; then
    sed -i 's|elijaharch/wl-screen-mirror|profidev/hypr-screen-mirror|g' "$CONF_DIR/noctalia/plugins.toml"
  fi

  if [ -f "$CONF_DIR/noctalia/bar.toml" ]; then
    sed -i 's|elijaharch/wl-screen-mirror:mirror|profidev/hypr-screen-mirror:widget|g' "$CONF_DIR/noctalia/bar.toml"
  fi

  echo "Hyprland installed successfully"
}
