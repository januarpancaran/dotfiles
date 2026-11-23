#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"

# Source all setup scripts
source "$SCRIPTS_DIR/utils.sh"
source "$SCRIPTS_DIR/setup-packages.sh"
source "$SCRIPTS_DIR/setup-brave.sh"
source "$SCRIPTS_DIR/setup-hyprland.sh"
source "$SCRIPTS_DIR/setup-umbriel.sh"
source "$SCRIPTS_DIR/setup-services.sh"
source "$SCRIPTS_DIR/setup-groups.sh"
source "$SCRIPTS_DIR/setup-dns.sh"
source "$SCRIPTS_DIR/setup-zram.sh"
source "$SCRIPTS_DIR/setup-configs.sh"

print_header() {
  echo "================================================"
  echo "  Dotfiles Installation Script"
  echo "  openSUSE Tumbleweed"
  echo "================================================"
  echo ""
}

print_summary() {
  echo ""
  echo "================================================"
  echo "  Installation Summary"
  echo "================================================"
  echo ""
  echo "✓ System packages installed"
  echo "✓ Third-party packages installed"
  echo "✓ Compositor installed"
  echo "✓ System services enabled"
  echo "✓ User groups configured"
  echo "✓ Configuration files copied"
  echo ""
  echo "================================================"
  echo "  Post-Installation Steps"
  echo "================================================"
  echo ""
  echo "1. LOGOUT and LOGIN again for group changes to take effect"
  echo "2. If you enabled ZRAM, verify with: swapon --show"
  echo "3. If you configured DNS, verify with: resolvectl status"
  echo "4. Source your shell config:"
  echo "   - For bash: source ~/.bashrc"
  echo "   - For zsh:  source ~/.zshrc"
  echo ""
  echo "Installation finished!"
}

main() {
  print_header

  echo "Updating system..."
  update_cmd

  echo ""
  install_zypper_packages

  echo ""
  install_opi_packages

  echo ""
  setup_brave

  echo ""
  echo "================================================"
  echo "  Compositor Selection"
  echo "================================================"
  echo ""
  echo "Choose your compositor:"
  echo "1) Hyprland (uses Noctalia from Tumbleweed repo)"
  echo "2) Umbriel (uses Noctalia from OBS repo)"
  echo ""
  read -rp "Enter choice [1-2]: " compositor_choice
  
  case "$compositor_choice" in
  1)
    echo "Installing Hyprland..."
    setup_hyprland
    ;;
  2)
    echo "Installing Umbriel..."
    install_obs_packages
    ;;
  *)
    echo "Invalid choice. Skipping compositor installation."
    ;;
  esac

  echo ""
  enable_services

  echo ""
  add_user_groups

  echo ""
  copy_configs

  echo ""
  echo "================================================"
  echo "  Optional Configurations"
  echo "================================================"
  echo ""

  user_choice "Cloudflare DNS configuration" setup_cloudflare_dns
  user_choice "ZRAM configuration" setup_zram
  
  echo ""
  change_shell

  print_summary
}

main "$@"
