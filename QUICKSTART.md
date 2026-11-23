# Quick Start Guide

## Installation in One Command

```bash
cd ~/Documents/github/dotfiles && ./install.sh
```

## What to Expect

The script will:
1. ✅ Refresh package repositories
2. ✅ Install ~60+ packages (this takes the longest)
3. ✅ Setup Brave browser with correct repository
4. ✅ Install Umbriel compositor from OBS
5. ✅ Enable system services (docker, gdm, databases, etc.)
6. ✅ Add you to the docker group
7. ✅ Copy all config files (with backups)
8. ❓ Ask if you want Cloudflare DNS (optional)
9. ❓ Ask if you want ZRAM (optional)
10. ❓ Ask if you want to change shell to zsh (optional)

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
./scripts/setup-packages.sh

# Just copy configs
./scripts/setup-configs.sh

# Just setup DNS
./scripts/setup-dns.sh

# Just setup ZRAM
./scripts/setup-zram.sh
```

## Backups

All existing configs are automatically backed up:
- Format: `filename.bak.YYYYMMDD_HHMMSS`
- Location: Same directory as original file

## Common Issues

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

Edit `packages.txt` to add/remove packages before running the installer.

## Need Help?

Check the full [README.md](README.md) for detailed documentation.
