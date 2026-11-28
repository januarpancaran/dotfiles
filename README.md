# Dotfiles Installation Script

Automated installation script for openSUSE Tumbleweed dotfiles and system configuration.

## Features

- **Automated Package Installation**: Installs essential packages
  - Official openSUSE packages via `zypper`
  - Third-party packages via `opi`
  - Brave browser from official repository
- **Compositor Selection**: Choose between Hyprland or Umbriel
- **Theme & Font Setup**:
  - Tela nord icon theme
  - JetBrains Mono Nerd Font
  - Dracula GTK-4 theme for Nautilus
- **System Configuration**:
  - Cloudflare Family DNS with DNS-over-TLS (optional)
  - ZRAM swap configuration (optional)
  - Systemd services management
  - User groups configuration
  - Graphical boot target
- **Dotfiles Management**: Copies compositor-specific configurations with automatic backups
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
- Multimedia codecs
- .NET SDK
- Dracula theme
- OnlyOffice
- Spotify
- VS Code
- Zotero

#### Themes & Fonts
- Tela nord icon theme (from GitHub)
- JetBrains Mono Nerd Font (from GitHub releases)
- Dracula GTK-4 theme symlinks for Nautilus

#### Compositor (Choose One)
**Hyprland**:
- hyprland, hyprland-guiutils, hyprland-devel
- xdg-desktop-portal-hyprland
- Noctalia (from Tumbleweed repo)
- Noctalia plugin: profidev/hypr-screen-mirror

**Umbriel**:
- umbriel-git (from OBS Noctalia repository)
- Noctalia (from OBS repo, newer version)
- Noctalia plugin: elijaharch/wl-screen-mirror

#### System Services
Automatically enabled:
- docker
- gdm
- mariadb
- postgresql
- power-profiles-daemon
- systemd-resolved
- systemd-zram-setup@zram0 (if ZRAM is configured)

Default boot target set to: `graphical.target`

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
- **hypr** (if Hyprland is selected)
- **umbriel** (if Umbriel is selected)

Copied to `~/`:
- .bashrc
- .ideavimrc
- .vimrc
- .zshrc

## Optional Configurations

During installation, you'll be prompted for:

### 1. Compositor Selection (Required)
Choose between:
- **Hyprland**: Popular Wayland compositor with Lua configuration
- **Umbriel**: Alternative compositor with TOML configuration

The installer will:
- Install compositor-specific packages
- Configure Noctalia with the appropriate screen mirror plugin
- Copy only the relevant compositor configuration files

### 2. Cloudflare DNS Configuration (Optional)
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

### 2. ZRAM Configuration (Optional)
Configures compressed swap in RAM:
- Size: 50% of physical RAM
- Compression: zstd
- Priority: 100

**File created**: `/etc/systemd/zram-generator.conf`

### 3. Shell Change (Optional)
Option to change default shell to zsh.

## Script Structure

```
dotfiles/
├── install.sh                    # Main orchestrator
├── hypr/                         # Hyprland configuration
├── umbriel/                      # Umbriel configuration
├── noctalia/                     # Noctalia configuration
└── scripts/
    ├── utils.sh                  # Core utilities
    ├── setup-packages.sh         # Package installation
    ├── setup-brave.sh            # Brave browser setup
    ├── setup-tela-icons.sh       # Tela icon theme
    ├── setup-jetbrains-font.sh   # JetBrains Mono Nerd Font
    ├── setup-dracula-gtk4.sh     # Dracula GTK-4 symlinks
    ├── setup-hyprland.sh         # Hyprland compositor
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
Some packages may fail to install. If this happens:

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

### Font Not Showing Up
After font installation, update font cache:

```bash
fc-cache -fv
```

### Compositor Not Starting
Make sure you logged out and back in after installation. Check if GDM is running:

```bash
systemctl status gdm
```

## Manual Installation Steps

If you prefer to run steps individually:

```bash
cd ~/Documents/github/dotfiles

# 1. Update system
sudo zypper refresh

# 2. Install packages
source scripts/utils.sh
source scripts/setup-packages.sh
install_zypper_packages
install_opi_packages

# 3. Setup themes and fonts
./scripts/setup-dracula-gtk4.sh
./scripts/setup-tela-icons.sh
./scripts/setup-jetbrains-font.sh

# 4. Setup Brave
./scripts/setup-brave.sh

# 5. Install compositor (choose one)
./scripts/setup-hyprland.sh   # OR
./scripts/setup-umbriel.sh

# 6. Enable services
source scripts/setup-services.sh
enable_services

# 7. Add user to groups
source scripts/setup-groups.sh
add_user_groups

# 8. Copy configs (set COMPOSITOR_CHOICE first)
export COMPOSITOR_CHOICE="hyprland"  # or "umbriel"
source scripts/setup-configs.sh
copy_configs

# 9. Optional: Configure DNS
source scripts/setup-dns.sh
setup_cloudflare_dns

# 10. Optional: Configure ZRAM
source scripts/setup-zram.sh
setup_zram
```

## Customization

### Adding Packages
Add packages to the arrays in `scripts/setup-packages.sh`:
- `ZYPPER_PACKAGES` - Official openSUSE packages
- `OPI_PACKAGES` - Third-party packages

### Switching Compositors Later
To switch from one compositor to another:

```bash
# If switching to Hyprland
export COMPOSITOR_CHOICE="hyprland"
./scripts/setup-hyprland.sh
source scripts/setup-configs.sh && copy_configs

# If switching to Umbriel
export COMPOSITOR_CHOICE="umbriel"
./scripts/setup-umbriel.sh
source scripts/setup-configs.sh && copy_configs
```

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
