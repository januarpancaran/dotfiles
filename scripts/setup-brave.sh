#!/bin/bash

setup_brave() {
  echo "Setting up Brave browser..."

  if "$SUDO_CMD" zypper lr | grep -q "brave-browser"; then
    echo "Brave repository already exists, skipping..."
  else
    echo "Adding Brave repository..."
    if ! add_repo brave-browser https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo; then
      echo "Failed to add Brave repository"
      return 1
    fi
  fi

  echo "Installing brave-origin package..."
  if ! install_cmd brave-origin; then
    echo "Failed to install brave-origin"
    return 1
  fi

  echo "Brave browser installed successfully"
}
