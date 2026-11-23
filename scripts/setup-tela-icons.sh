#!/bin/bash

setup_tela_icons() {
  echo "Setting up Tela icon theme..."

  set_local_dir

  local tela_dir="$LOCAL_DIR/tela-icon-theme"

  if [ -d "$tela_dir" ]; then
    echo "Tela icon theme repository already exists, pulling latest changes..."
    cd "$tela_dir"
    git pull || {
      echo "Failed to update Tela icon theme repository"
      return 1
    }
  else
    echo "Cloning Tela icon theme repository..."
    git clone https://github.com/vinceliuice/Tela-icon-theme.git "$tela_dir" || {
      echo "Failed to clone Tela icon theme repository"
      return 1
    }
    cd "$tela_dir"
  fi

  echo "Installing Tela nord icon theme..."
  if ! ./install.sh nord; then
    echo "Failed to install Tela nord icon theme"
    return 1
  fi

  echo "Cleaning up..."
  cd "$HOME"
  rm -rf "$tela_dir"

  echo "Tela icon theme installed successfully"
}
