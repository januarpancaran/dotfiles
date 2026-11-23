#!/bin/bash

setup_umbriel() {
  echo "Setting up Umbriel compositor..."

  local repo_url="https://download.opensuse.org/repositories/home:neifua:Noctalia/openSUSE_Tumbleweed/home:neifua:Noctalia.repo"
  local repo_name="home_neifua_Noctalia"

  if "$SUDO_CMD" zypper lr | grep -q "$repo_name"; then
    echo "Noctalia repository already exists, skipping..."
  else
    echo "Adding Noctalia OBS repository..."
    "$SUDO_CMD" zypper addrepo \
      --refresh \
      --name Noctalia \
      "$repo_url" || {
      echo "Failed to add Noctalia repository"
      return 1
    }
  fi

  echo "Refreshing repositories..."
  "$SUDO_CMD" zypper refresh

  echo "Installing umbriel-git..."
  if ! install_cmd umbriel-git; then
    echo "Failed to install umbriel-git"
    return 1
  fi

  echo "Umbriel installed successfully"
}
