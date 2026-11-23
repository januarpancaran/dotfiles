#!/bin/bash

setup_jetbrains_font() {
  echo "Setting up JetBrains Mono Nerd Font..."

  local font_dir="$HOME/.fonts/JetBrainsMono"

  if [ -d "$font_dir" ] && [ -n "$(ls -A "$font_dir"/*.ttf 2>/dev/null)" ]; then
    echo "JetBrains Mono Nerd Font already installed, skipping..."
    return 0
  fi

  echo "Creating font directory..."
  mkdir -p "$font_dir"

  echo "Downloading JetBrains Mono Nerd Font..."
  local download_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  local temp_zip="/tmp/JetBrainsMono.zip"

  if ! curl -fsSL -o "$temp_zip" "$download_url"; then
    echo "Failed to download JetBrains Mono Nerd Font"
    return 1
  fi

  echo "Extracting font files..."
  if ! unzip -q "$temp_zip" -d "$font_dir"; then
    echo "Failed to extract JetBrains Mono Nerd Font"
    rm -f "$temp_zip"
    return 1
  fi

  echo "Cleaning up..."
  rm -f "$temp_zip"

  echo "Updating font cache..."
  fc-cache -fv "$font_dir" >/dev/null 2>&1

  echo "JetBrains Mono Nerd Font installed successfully"
}
