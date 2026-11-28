#!/bin/bash

setup_dracula_gtk4() {
  echo "Setting up Dracula GTK theme configuration..."

  set_config_dir

  local gtk3_dir="$CONF_DIR/gtk-3.0"
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

  # Create GTK-3.0 config directory and copy settings
  echo "Setting up GTK-3.0 configuration..."
  mkdir -p "$gtk3_dir"
  
  if [ -f "$ROOT_DIR/gtk-3.0/settings.ini" ]; then
    if [ -f "$gtk3_dir/settings.ini" ]; then
      backup_file "$gtk3_dir/settings.ini"
    fi
    cp "$ROOT_DIR/gtk-3.0/settings.ini" "$gtk3_dir/settings.ini"
    echo "✓ Copied GTK-3.0 settings.ini"
  fi

  # Create GTK-4.0 config directory
  echo "Setting up GTK-4.0 configuration..."
  mkdir -p "$gtk4_dir"

  # Copy settings.ini
  if [ -f "$ROOT_DIR/gtk-4.0/settings.ini" ]; then
    if [ -f "$gtk4_dir/settings.ini" ] || [ -L "$gtk4_dir/settings.ini" ]; then
      backup_file "$gtk4_dir/settings.ini"
    fi
    cp "$ROOT_DIR/gtk-4.0/settings.ini" "$gtk4_dir/settings.ini"
    echo "✓ Copied GTK-4.0 settings.ini"
  fi

  # Create Dracula theme symlinks
  echo "Creating Dracula GTK-4 theme symlinks..."
  
  # Remove existing symlinks/files if they exist
  [ -L "$gtk4_assets_link" ] && rm -f "$gtk4_assets_link"
  [ -L "$gtk4_css_link" ] && rm -f "$gtk4_css_link"
  [ -L "$gtk4_dark_css_link" ] && rm -f "$gtk4_dark_css_link"

  # Create symlinks
  ln -sf "$dracula_gtk4_src/assets" "$gtk4_assets_link"
  ln -sf "$dracula_gtk4_src/gtk.css" "$gtk4_css_link"
  ln -sf "$dracula_gtk4_src/gtk-dark.css" "$gtk4_dark_css_link"

  echo "Dracula GTK theme configuration completed successfully"
}
