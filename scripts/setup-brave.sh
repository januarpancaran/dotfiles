#!/bin/bash

setup_brave() {
  echo "Setting up Brave browser..."

  if "$SUDO_CMD" zypper lr | grep -q "brave-browser"; then
    echo "Brave repository already exists, skipping..."
  else
    echo "Adding Brave repository..."
    add_repo brave-browser https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
  fi

  echo "Installing brave-origin package..."
  install_cmd brave-origin

  echo "Brave browser installed successfully"
}
