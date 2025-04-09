#!/bin/sh

# Checking aur helper
AUR_HELPER=""
if [ -f /usr/bin/yay ]; then
	AUR_HELPER="yay"
elif [ -f /usr/bin/paru ]; then
	AUR_HELPER="paru"
else
	echo "No AUR Helper installed. Installing yay"
	sudo pacman -S base-devel git --needed
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm
	cd ..
	rm -rf yay

	echo "yay installed!"
	AUR_HELPER="yay"
fi

# Installing needed packages
echo "Installing Packages..."
$AUR_HELPER -S --needed --noconfirm base-devel bluez bluez-utils networkmanager hyprland ghostty polkit-gnome brightnessctl pipewire wireplumber waybar dunst hypridle hyprlock rofi-wayland hyprpaper wlogout qt5-wayland qt6-wayland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xwaylandvideobridge hyprshot wl-clipboard htop trash-cli alsa-utils alsa-firmware pipewire-pulse pipewire-alsa blueberry xorg-xhost bat fastfetch eog unzip zip unrar wget openssh xdg-desktop-portal libnotify zoxide playerctl fzf ripgrep pavucontrol acpi neovim google-chrome mpv zsh starship nodejs cronie nautilus npm gvfs-mtp gvfs-afc tmux network-manager-applet xdg-desktop-portal-wlr papirus-icon-theme gtk-engine-murrine gnome-themes-extra gnome-control-center dracula-gtk-theme dracula-icons-theme bibata-cursor-theme-bin yazi

# Installing needed fonts
echo "Installing Fonts..."
$AUR_HELPER -S ttf-meslo-nerd ttf-jetbrains-mono-nerd ttf-space-mono-nerd otf-font-awesome ttf-material-symbols-variable-git noto-fonts-emoji noto-fonts-cjk --noconfirm

# Enabling Services
sudo systemctl enable --now NetworkManager bluetooth cronie
systemctl enable --user --now pipewire.socket pipewire.service

# Moving all the dotfiles
if [ ! -d "$HOME/.config" ]; then
	mkdir -p "$(dirname $HOME/.config)"
fi

CONFIG_SRC="./Configs/"
CONFIG_DES="$HOME/.config"

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

if [ ! -d "$LOCAL_BIN_DES" ]; then
	mkdir -p "$LOCAL_BIN_DES"
fi

for files in "$LOCAL_BIN_SRC"*; do
	cp "$files" "$LOCAL_BIN_DES"
done

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
ln -s /usr/share/themes/Dracula/gtk-4.0 $HOME/.config/gtk-4.0

# Systemd timers
echo "Creating systemd timers..."
SYSTEMD_DIR="$HOME/.config/systemd/user/"

if [ ! -d "$SYSTEMD_DIR" ]; then
	mkdir -p "$SYSTEMD_DIR"
fi

# Battery notification
cat >"$SYSTEMD_DIR/batterynotify.service" <<EOF
[Unit] 
Description=Battery Notification Script

[Service]
ExecStart=%h/.local/bin/batterynotify
EOF

cat >"$SYSTEMD_DIR/batterynotify.timer" <<EOF
[Unit]
Description=Run Battery Notification Script every 5 minutes

[Timer]
OnCalendar=*:0/5
Unit=batterynotify.service

[Install]
WantedBy=timers.target
EOF

# Trash emptying
cat >"$SYSTEMD_DIR/trash-empty.service" <<EOF
[Unit] 
Description=Empty Trash older than 30 days

[Service]
ExecStart=/sbin/trash-empty 30
EOF

cat >"$SYSTEMD_DIR/trash-empty.timer" <<EOF
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
echo "Creating power udev rules..."

USERNAME=$(whoami)
HOME_DIR=$HOME
UDEV_RULES_FILE="/etc/udev/rules.d/99-chargingnotify.rules"
CHARGING_NOTIFY_SCRIPT="$HOME_DIR/.local/bin/chargingnotify"
WAYLAND_DISPLAY="wayland-0"
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

if [ ! -x "$CHARGING_NOTIFY_SCRIPT" ]; then
	echo "Error: $CHARGING_NOTIFY_SCRIPT does not exist or is not executable."
	exit 1
fi

# Creating the udev rules
sudo bash -c "cat > $UDEV_RULES_FILE" <<EOF
ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="1", ENV{WAYLAND_DISPLAY}="$WAYLAND_DISPLAY", ENV{DBUS_SESSION_BUS_ADDRESS}="$DBUS_SESSION_BUS_ADDRESS" RUN+="/usr/bin/su $USERNAME -c '$CHARGING_NOTIFY_SCRIPT 1'"
ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="0", ENV{WAYLAND_DISPLAY}="$WAYLAND_DISPLAY", ENV{DBUS_SESSION_BUS_ADDRESS}="$DBUS_SESSION_BUS_ADDRESS" RUN+="/usr/bin/su $USERNAME -c '$CHARGING_NOTIFY_SCRIPT 0'"
EOF

sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Installation finished!"
