# Dotfiles Installation Script

Automated installation script for openSUSE Tumbleweed dotfiles and system configuration.

## Features

- **Automated Package Installation**: Installs all packages from `packages.txt`
  - Official openSUSE packages via `zypper`
  - Third-party packages via `opi`
  - OBS packages (Umbriel compositor)
- **System Configuration**:
  - Cloudflare Family DNS with DNS-over-TLS (optional)
  - ZRAM swap configuration (optional)
  - Systemd services management
  - User groups configuration
- **Dotfiles Management**: Copies all configuration files with automatic backups
- **Modular Design**: Easy to maintain and customize

## Prerequisites

- openSUSE Tumbleweed
- `sudo` or `doas` access
- Internet connection

## Installation

### Quick Start

```bash
cd ~/Documents/github/dotfiles
./install.sh
```

### What Gets Installed

#### System Packages (via zypper)
- Development tools: git, gh, neovim, docker, go, ruby
- Terminal utilities: fastfetch, bat, fzf, ripgrep, zoxide, starship, zsh
- Multimedia: mpv, obs-studio, mangohud, gamemode
- Desktop: gdm, gnome-control-center, loupe, papers
- Fonts: google-noto-*, fetchmsttfonts
- Wayland tools: grim, slurp, wl-clipboard, wl-mirror, wlsunset
- Database: mariadb, postgresql
- And more...

#### Third-party Packages (via opi)
- Bibata cursor theme
- Brave browser (brave-origin)
- Multimedia codecs
- .NET SDK
- Dracula theme
- OnlyOffice
- Spotify
- VS Code
- Zotero

#### OBS Packages
- Umbriel compositor (Noctalia repository)
- Noctalia shell

#### System Services
Automatically enabled:
- docker
- gdm
- mariadb
- postgresql
- power-profiles-daemon
- systemd-resolved
- systemd-zram-setup@zram0 (if ZRAM is configured)

#### User Groups
- docker

#### Configuration Files
Copied to `~/.config/`:
- MangoHud
- fastfetch
- ghostty
- mpv
- noctalia
- starship
- umbriel

Copied to `~/`:
- .bashrc
- .ideavimrc
- .vimrc
- .zshrc

## Optional Configurations

During installation, you'll be prompted for:

### 1. Cloudflare DNS Configuration
Configures Cloudflare Family DNS (1.1.1.3) with:
- DNS-over-TLS encryption
- Malware blocking
- Adult content filtering
- Automatic fallback configuration

**Files modified**:
- `/etc/systemd/resolved.conf.d/cloudflare.conf`
- `/etc/NetworkManager/conf.d/dns.conf`
- `/etc/sysconfig/network/config`
- `/etc/resolv.conf`

### 2. ZRAM Configuration
Configures compressed swap in RAM:
- Size: 50% of physical RAM
- Compression: zstd
- Priority: 100

**File created**: `/etc/systemd/zram-generator.conf`

### 3. Shell Change
Option to change default shell to zsh.

## Script Structure

```
dotfiles/
├── install.sh                    # Main orchestrator
├── packages.txt                  # Package list
└── scripts/
    ├── utils.sh                  # Core utilities
    ├── setup-packages.sh         # Package installation
    ├── setup-brave.sh            # Brave browser setup
    ├── setup-umbriel.sh          # Umbriel compositor
    ├── setup-services.sh         # Systemd services
    ├── setup-groups.sh           # User groups
    ├── setup-dns.sh              # DNS configuration
    ├── setup-zram.sh             # ZRAM configuration
    └── setup-configs.sh          # Dotfiles copying
```

## Post-Installation

After installation completes:

1. **Logout and login** for group changes to take effect
2. **Verify ZRAM** (if enabled):
   ```bash
   swapon --show
   ```
3. **Verify DNS** (if configured):
   ```bash
   resolvectl status
   ```
4. **Source your shell config**:
   ```bash
   # For bash
   source ~/.bashrc
   
   # For zsh
   source ~/.zshrc
   ```

## Backup Strategy

The script automatically backs up existing configuration files before overwriting:
- Backups are created with timestamp: `filename.bak.YYYYMMDD_HHMMSS`
- Both files and directories are backed up
- Backups are never overwritten

## Troubleshooting

### Package Installation Failures
Some package names in `packages.txt` may not match exactly with openSUSE repositories. If a package fails:

```bash
# Search for the correct package name
zypper search <package-name>

# Install manually
sudo zypper install <correct-package-name>
```

### Service Enablement Failures
If a service fails to enable, check if the package is installed:

```bash
systemctl status <service-name>
sudo zypper install <package-providing-service>
```

### OPI Not Found
If `opi` is not available:

```bash
sudo zypper install opi
```

### Brave Installation Issues
Brave requires a two-step process:
1. `opi brave` - Adds repository and signs keys
2. `zypper install brave-origin` - Installs the actual browser

This is handled automatically by the script.

## Manual Installation Steps

If you prefer to run steps individually:

```bash
cd ~/Documents/github/dotfiles

# 1. Update system
sudo zypper refresh

# 2. Install packages
./scripts/setup-packages.sh

# 3. Setup Brave
./scripts/setup-brave.sh

# 4. Install Umbriel
./scripts/setup-umbriel.sh

# 5. Enable services
./scripts/setup-services.sh

# 6. Add user to groups
./scripts/setup-groups.sh

# 7. Copy configs
./scripts/setup-configs.sh

# 8. Optional: Configure DNS
./scripts/setup-dns.sh

# 9. Optional: Configure ZRAM
./scripts/setup-zram.sh
```

## Customization

### Adding Packages
Edit `packages.txt` and add packages under the appropriate section:
- `# Zypper` - Official openSUSE packages
- `# Opi` - Third-party packages
- `# Services` - Services to enable
- `# Group` - Groups to add user to

### Modifying Configurations
Edit the respective script in `scripts/` directory.

### Adding New Setup Scripts
1. Create new script in `scripts/` directory
2. Source it in `install.sh`
3. Call the setup function in `main()`

## Safety Features

- **Error handling**: `set -euo pipefail` for strict error checking
- **Backup before overwrite**: All existing configs are backed up
- **Non-destructive**: Failed package installations don't stop the entire process
- **Idempotent**: Safe to run multiple times
- **User prompts**: Optional installations require confirmation

## License

See LICENSE file.

## Notes

- Designed specifically for openSUSE Tumbleweed
- Uses `zypper` for package management
- Requires `opi` for third-party repositories
- Some package names may need verification via `zypper search`
