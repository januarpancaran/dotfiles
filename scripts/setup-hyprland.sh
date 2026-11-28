#!/bin/bash

setup_hyprland() {
  echo "Setting up Hyprland compositor..."

  set_config_dir

  echo "Installing Hyprland packages..."
  if ! install_cmd hyprland hyprland-guiutils hyprland-devel xdg-desktop-portal-hyprland noctalia; then
    echo "Failed to install Hyprland packages"
    return 1
  fi

  echo "Configuring Noctalia screen mirror plugin for Hyprland..."
  if [ -f "$ROOT_DIR/noctalia/plugins.toml" ]; then
    sed -i 's|elijaharch/wl-screen-mirror|profidev/hypr-screen-mirror|g' "$ROOT_DIR/noctalia/plugins.toml"
  fi

  if [ -f "$ROOT_DIR/noctalia/bar.toml" ]; then
    sed -i 's|elijaharch/wl-screen-mirror:mirror|profidev/hypr-screen-mirror:widget|g' "$ROOT_DIR/noctalia/bar.toml"
  fi

  echo "Hyprland installed successfully"
}
