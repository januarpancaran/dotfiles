#!/bin/bash

cmd_exists() {
  command -v "$1" > /dev/null 2>&1
}

SUDO_CMD=""

if cmd_exists doas; then
  SUDO_CMD="doas"
else
  SUDO_CMD="sudo"
fi

set_config_dir() {
  CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
  mkdir -p "$CONF_DIR"
}

set_local_dir() {
  LOCAL_DIR="$HOME/.local"
  mkdir -p "$LOCAL_DIR"
}

backup_dir() {
  local dir="$1"
  [ -d "$dir" ] && mv -v "$dir" "${dir}.bak.$(date +%Y%m%d_%H%M%S)"
}

backup_file() {
  local file="$1"
  [ -f "$file" ] && mv -v "$file" "${file}.bak.$(date +%Y%m%d_%H%M%S)"
}

install_cmd() {
  "$SUDO_CMD" zypper --no-refresh install -y "$@"
}

update_cmd() {
  "$SUDO_CMD" zypper refresh
}

delete_cmd() {
  "$SUDO_CMD" zypper remove -y "$@"
}

opi_cmd() {
  opi "$@"
}

add_repo() {
  local name="$1"
  local url="$2"
  "$SUDO_CMD" zypper addrepo --refresh --name "$name" "$url"
}

link_file() {
  mkdir -p "$(dirname "$2")"
  ln -sf "$1" "$2"
}

add_group() {
  "$SUDO_CMD" usermod -aG "$1" $USER
}

enable_service() {
  "$SUDO_CMD" systemctl enable --now "$@"
}

user_choice() {
  local label="$1"
  shift

  read -rp "Install optional ${label}? [y/N] " choice

  case "$choice" in
  [Yy]*)
    echo "Installing ${label}..."
    "$@"
    ;;
  *)
    echo "Skipping ${label}"
    ;;
  esac
}

change_shell() {
  if [ "$SHELL" = "$(command -v zsh)" ]; then
    echo "Shell is already zsh"
    return 0
  fi

  read -rp "Change shell to zsh? [y/N] " shell_choice

  case "$shell_choice" in
  [Yy]*)
    chsh -s "$(command -v zsh)"
    echo "Shell changed to zsh. Please logout and login again."
    ;;
  *)
    echo "Shell not changed"
    ;;
  esac
}
