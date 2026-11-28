#!/bin/bash

setup_hyprland() {
  echo "Setting up Hyprland compositor..."

  echo "Installing Hyprland packages..."
  if ! install_cmd hyprland hyprland-guiutils hyprland-devel xdg-desktop-portal-hyprland noctalia; then
    echo "Failed to install Hyprland packages"
    return 1
  fi

  echo "Hyprland installed successfully"
}
