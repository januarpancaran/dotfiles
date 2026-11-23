#!/bin/bash

setup_dracula_gtk4() {
  echo "Setting up Dracula GTK-4 theme symlink for Nautilus..."

  set_config_dir

  local gtk4_dir="$CONF_DIR/gtk-4.0"
  local dracula_gtk4_src="/usr/share/themes/dracula-gtk-theme/gtk-4.0"
  local gtk4_assets_link="$gtk4_dir/assets"
  local gtk4_css_link="$gtk4_dir/gtk.css"
  local gtk4_dark_css_link="$gtk4_dir/gtk-dark.css"

  if [ ! -d "$dracula_gtk4_src" ]; then
    echo "Dracula GTK theme not found at $dracula_gtk4_src"
    echo "Make sure dracula theme is installed via opi"
    return 1
  fi

  echo "Creating GTK-4.0 config directory..."
  mkdir -p "$gtk4_dir"

  echo "Creating symlinks..."
  
  # Remove existing symlinks/files if they exist
  [ -L "$gtk4_assets_link" ] && rm -f "$gtk4_assets_link"
  [ -L "$gtk4_css_link" ] && rm -f "$gtk4_css_link"
  [ -L "$gtk4_dark_css_link" ] && rm -f "$gtk4_dark_css_link"

  # Create symlinks
  ln -sf "$dracula_gtk4_src/assets" "$gtk4_assets_link"
  ln -sf "$dracula_gtk4_src/gtk.css" "$gtk4_css_link"
  ln -sf "$dracula_gtk4_src/gtk-dark.css" "$gtk4_dark_css_link"

  echo "Dracula GTK-4 theme symlinks created successfully"
}
