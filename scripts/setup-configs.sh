#!/bin/bash

copy_configs() {
  echo "Copying configuration files..."

  set_config_dir

  # Config directories to copy to ~/.config
  local -a conf_dirs=(
    MangoHud
    fastfetch
    ghostty
    mpv
    noctalia
    starship
  )

  # Add compositor-specific config
  if [ "${COMPOSITOR_CHOICE:-}" = "hyprland" ]; then
    conf_dirs+=(hypr)
  elif [ "${COMPOSITOR_CHOICE:-}" = "umbriel" ]; then
    conf_dirs+=(umbriel)
  fi

  # Home files to copy to ~/
  local -a home_files=(
    .bashrc
    .ideavimrc
    .vimrc
    .zshrc
  )

  echo "Copying config directories to $CONF_DIR..."
  for dir in "${conf_dirs[@]}"; do
    local src="$ROOT_DIR/$dir"
    
    if [ ! -d "$src" ]; then
      echo "Skipping $dir (not found)"
      continue
    fi

    local dest="${CONF_DIR}/$dir"

    if [ -e "$dest" ]; then
      backup_dir "$dest"
    fi

    cp -r "$src" "$dest"
    echo "✓ Copied $dir -> $dest"
  done

  echo ""
  echo "Copying dotfiles to home directory..."
  for file in "${home_files[@]}"; do
    local src="$ROOT_DIR/$file"
    
    if [ ! -f "$src" ]; then
      echo "Skipping $file (not found)"
      continue
    fi

    local dest="$HOME/$file"

    if [ -f "$dest" ]; then
      backup_file "$dest"
    fi

    cp "$src" "$dest"
    echo "✓ Copied $file -> $dest"
  done

  echo ""
  echo "Configuration files copied successfully!"
  echo "Backups are saved with timestamp extensions (.bak.YYYYMMDD_HHMMSS)"
}
