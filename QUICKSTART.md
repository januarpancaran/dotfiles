# Quick Start Guide

## Installation in One Command

```bash
cd ~/Documents/github/dotfiles && ./install.sh
```

## What to Expect

The script will:
1. ✅ Refresh package repositories
2. ✅ Install ~60+ packages (this takes the longest)
3. ✅ Setup Dracula GTK theme with custom settings
4. ✅ Setup Brave browser from official repository
5. ✅ Install Tela nord icon theme
6. ✅ Install JetBrains Mono Nerd Font
7. ✅ Install Hyprland compositor
8. ✅ Enable system services and set graphical boot target
9. ✅ Add you to the docker group
10. ✅ Copy config files (with backups)
11. ❓ Ask if you want Cloudflare DNS (optional)
12. ❓ Ask if you want ZRAM (optional)
13. ❓ Ask if you want to change shell to zsh (optional)

## Post-Installation (IMPORTANT!)

```bash
# 1. LOGOUT AND LOGIN for group changes
logout

# 2. After logging back in, source your shell config
source ~/.zshrc    # if you use zsh
source ~/.bashrc   # if you use bash

# 3. Verify ZRAM (if you enabled it)
swapon --show

# 4. Verify DNS (if you configured it)
resolvectl status
```

## If Something Fails

The script continues even if individual packages fail. Check the warnings:

```bash
# Search for correct package name
zypper search <package-name>

# Install manually
sudo zypper install <package-name>
```

## Run Specific Parts Only

```bash
# Just install packages
source scripts/utils.sh
source scripts/setup-packages.sh
install_zypper_packages

# Just install Hyprland
./scripts/setup-hyprland.sh

# Just copy configs
source scripts/setup-configs.sh
copy_configs

# Just setup DNS
source scripts/setup-dns.sh
setup_cloudflare_dns

# Just setup ZRAM
source scripts/setup-zram.sh
setup_zram
```

## Backups

All existing configs are automatically backed up:
- Format: `filename.bak.YYYYMMDD_HHMMSS`
- Location: Same directory as original file

## Common Issues

### Compositor not starting
**Solution**: Make sure you logged out and back in
```bash
systemctl status gdm
```

### Font not showing in terminal
**Solution**: Update font cache
```bash
fc-cache -fv
fc-list | grep JetBrains
```

### Noctalia screen mirror plugin wrong
**Solution**: Check which compositor you chose. The plugin is automatically configured based on your selection.

### Package not found
**Solution**: Search for the correct name
```bash
zypper search <package>
```

### Service failed to enable
**Solution**: Install the package providing the service
```bash
sudo zypper install <service-package>
```

### Permission denied
**Solution**: Make sure scripts are executable
```bash
chmod +x install.sh scripts/*.sh
```

## Customization

To add more packages, edit the arrays in `scripts/setup-packages.sh`:
- `ZYPPER_PACKAGES` - Official repos
- `OPI_PACKAGES` - Third-party repos

## Need Help?

Check the full [README.md](README.md) for detailed documentation.
