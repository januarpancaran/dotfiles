#!/bin/bash

ZYPPER_PACKAGES=(
  7zip
  ImageMagick
  ProtonPlus
  bat
  chafa
  discord
  docker
  docker-compose
  docker-compose-switch
  fastfetch
  fd
  fetchmsttfonts
  ffmpegthumbnailer
  fzf
  gamemode
  gdm
  gh
  ghostty
  git
  gnome-control-center
  gnome-keyring
  go
  google-noto-coloremoji-fonts
  google-noto-fonts
  google-noto-sans-cjk-fonts
  grim
  htop
  java-27-openjdk-devel
  libnotify-tools
  loupe
  mangohud
  mariadb
  mpv
  neovim
  noctalia
  obs-studio
  papers
  polkit-gnome
  postgresql
  postgresql-contrib
  postgresql-server
  postgresql18-pgvector
  power-profiles-daemon
  ripgrep
  ruby
  slurp
  socat
  starship
  steam
  systemd-resolved
  telegram-desktop
  trash-cli
  tree
  unrar
  wl-clipboard
  wl-mirror
  wlsunset
  yazi
  zed
  zoxide
  zram-generator
  zsh
)

OPI_PACKAGES=(
  bibata
  codecs
  dotnet
  dracula
  onlyoffice
  spotify
  zotero
)

install_zypper_packages() {
  echo "Installing zypper packages..."
  echo "This may take a while..."

  local failed_packages=()

  for package in "${ZYPPER_PACKAGES[@]}"; do
    echo "Installing $package..."
    if ! install_cmd "$package"; then
      echo "Warning: Failed to install $package"
      failed_packages+=("$package")
    fi
  done

  if [ ${#failed_packages[@]} -gt 0 ]; then
    echo ""
    echo "The following packages failed to install:"
    printf '%s\n' "${failed_packages[@]}"
    echo ""
    echo "You may need to verify package names with: zypper search <package>"
  fi
}

install_opi_packages() {
  if ! cmd_exists opi; then
    echo "opi not found. Installing opi..."
    install_cmd opi || {
      echo "Failed to install opi. Skipping opi packages."
      return 1
    }
  fi

  echo "Installing opi packages..."

  local failed_packages=()

  for package in "${OPI_PACKAGES[@]}"; do
    echo "Installing $package via opi..."
    if ! opi_cmd "$package"; then
      echo "Warning: Failed to install $package"
      failed_packages+=("$package")
    fi
  done

  if [ ${#failed_packages[@]} -gt 0 ]; then
    echo ""
    echo "The following opi packages failed to install:"
    printf '%s\n' "${failed_packages[@]}"
  fi
}
