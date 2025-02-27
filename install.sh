#!/bin/sh

# Checking if zypper is available
if ! command -v zypper &> /dev/null; then
    echo "zypper not found! Please make sure you are using an OpenSUSE system."
    exit 1
fi

# Installing needed packages
echo "Installing Packages..."
sudo zypper install -y bluez NetworkManager hyprland hyprland-qtutils ghostty polkit brightnessctl pipewire wireplumber waybar dunst hypridle hyprlock rofi-wayland swww wlogout libqt5-qtwayland libQt6WaylandClient6 libQt6WaylandCompositor6 libQt6WaylandEglClientHwIntegration6 libQt6WaylandEglCompositorHwIntegration6 xdg-desktop-portal-hyprland xdg-desktop-portal-gtk grim slurp wl-clipboard htop trash-cli alsa-utils alsa-firmware pipewire-pulseaudio pipewire-alsa blueman xhost bat fastfetch eog unzip unrar wget openssh xdg-desktop-portal libnotify4 zoxide playerctl fzf ripgrep pavucontrol acpi neovim MozillaFirefox mpv zsh starship nodejs22 cronie nautilus gvfs gvfs-backends gvfs-backend-afc tmux NetworkManager-applet xdg-desktop-portal-wlr papirus-icon-theme gtk2-engine-murrine gnome-themes-extras gnome-control-center libnotify-tools yazi

# Installing needed fonts
echo "Installing Fonts..."
sudo zypper install -y meslo-lg-fonts jetbrains-mono-fonts fontawesome-fonts google-noto-coloremoji-fonts google-noto-sans-cjk-fonts

mkdir ~/.fonts
mkdir fonts
cd fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip
unzip JetBrainsMono.zip
mv *.ttf ~/.fonts
rm -rf *

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Meslo.zip
unzip Meslo.zip
mv *.ttf ~/.fonts
rm -rf *

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/SpaceMono.zip
unzip SpaceMono.zip
mv *.ttf ~/.fonts
rm -rf *
cd ..

rm -rf fonts
fc-cache -vf

# Enabling Services
sudo systemctl enable --now NetworkManager bluetooth 
systemctl --user enable --now pipewire.socket pipewire.service

# Moving all the dotfiles
CONFIG_SRC="./Configs/"
CONFIG_DES="$HOME/.config"

mkdir -p "$CONFIG_DES"

for dirs in "$CONFIG_SRC"*; do
    base_dirs=$(basename "$dirs")
    des_dirs="$CONFIG_DES/$base_dirs"
    
    if [ -d "$des_dirs" ]; then
        mv -v "$des_dirs" "${des_dirs}-old"
    fi
    
    cp -r "$dirs" "$des_dirs"
done

LOCAL_BIN_SRC="./.local/bin/"
LOCAL_BIN_DES="$HOME/.local/bin/"
mkdir -p "$LOCAL_BIN_DES"

cp "$LOCAL_BIN_SRC"* "$LOCAL_BIN_DES"

# Moving zshrc
cp ./.zshrc "$HOME"

# Installing tpm for tmux
git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm

# Changing default shell
echo "Changing Default Shell to zsh..."
echo "Change Shell? [y/N]"
read -r confirmation

if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    if chsh -s "$(which zsh)"; then
        echo "Default shell changed successfully."
    else
        echo "Failed to change default shell."
    fi
else
    echo "Default shell not changed."
fi

# Installing dracula gtk theme and icons
THEME_DIR="$HOME/.themes"
mkdir -p "$THEME_DIR"

wget https://github.com/dracula/gtk/archive/master.zip
unzip master.zip
rm -rf master.zip
mv gtk-master Dracula
mv Dracula "$THEME_DIR"

mkdir -p "$HOME/.config/gtk-4.0"
ln -s "$THEME_DIR/Dracula/gtk-4.0/assets" "$HOME/.config/gtk-4.0/assets"
ln -s "$THEME_DIR/Dracula/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
ln -s "$THEME_DIR/Dracula/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"

ICON_DIR="$HOME/.icons"
mkdir -p "$ICON_DIR"

wget https://github.com/dracula/gtk/files/5214870/Dracula.zip
unzip Dracula.zip
rm -rf Dracula.zip
mv Dracula "$ICON_DIR"

# Systemd timers
SYSTEMD_DIR="$HOME/.config/systemd/user/"
mkdir -p "$SYSTEMD_DIR"

cat > "$SYSTEMD_DIR/batterynotify.service" <<EOF
[Unit] 
Description=Battery Notification Script

[Service]
ExecStart=%h/.local/bin/batterynotify
EOF

cat > "$SYSTEMD_DIR/batterynotify.timer" <<EOF
[Unit]
Description=Run Battery Notification Script every 5 minutes

[Timer]
OnCalendar=*:0/5
Unit=batterynotify.service

[Install]
WantedBy=timers.target
EOF

cat > "$SYSTEMD_DIR/trash-empty.service" <<EOF
[Unit] 
Description=Empty Trash older than 30 days

[Service]
ExecStart=/usr/bin/trash-empty 30
EOF

cat > "$SYSTEMD_DIR/trash-empty.timer" <<EOF
[Unit]
Description=Run Trash Emptying Daily

[Timer]
OnCalendar=daily
Unit=trash-empty.service

[Install]
WantedBy=timers.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now batterynotify.timer
systemctl --user enable --now trash-empty.timer

# Power udev rules
USERNAME=$(whoami)
HOME_DIR=$HOME
UDEV_RULES_FILE="/etc/udev/rules.d/99-chargingnotify.rules"
CHARGING_NOTIFY_SCRIPT="$HOME_DIR/.local/bin/chargingnotify"
WAYLAND_DISPLAY="wayland-0"
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

if [ ! -x "$CHARGING_NOTIFY_SCRIPT" ]; then
    echo "Error: $CHARGING_NOTIFY_SCRIPT does not exist or is not executable."
    exit 1
fi

sudo bash -c "cat > $UDEV_RULES_FILE" <<EOF
ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="1", ENV{WAYLAND_DISPLAY}="$WAYLAND_DISPLAY", ENV{DBUS_SESSION_BUS_ADDRESS}="$DBUS_SESSION_BUS_ADDRESS" RUN+="/usr/bin/su $USERNAME -c '$CHARGING_NOTIFY_SCRIPT 1'"
ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="0", ENV{WAYLAND_DISPLAY}="$WAYLAND_DISPLAY", ENV{DBUS_SESSION_BUS_ADDRESS}="$DBUS_SESSION_BUS_ADDRESS" RUN+="/usr/bin/su $USERNAME -c '$CHARGING_NOTIFY_SCRIPT 0'"
EOF

sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Installation finished!"
