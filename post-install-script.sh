#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Update system
echo "Updating system..."
pacman -Syu --noconfirm

# Install Wayland and dependencies
echo "Installing Wayland and essential packages..."
pacman -S --noconfirm wayland xorg-xwayland

# Install SDDM (display manager) and enable it
echo "Installing and enabling SDDM..."
pacman -S --noconfirm sddm
systemctl enable sddm.service

# Detect non-root user for AUR installation
USER_HOME="/home/$(logname)"
NON_ROOT_USER=$(logname)

# Install paru (AUR helper) as non-root user
echo "Checking for paru..."
if ! command -v paru &> /dev/null; then
  echo "paru not found, installing paru (AUR helper)..."
  pacman -S --needed --noconfirm base-devel git
  sudo -u "$NON_ROOT_USER" bash <<EOF
  cd "$USER_HOME"
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si --noconfirm
  cd ..
  rm -rf paru
EOF
fi

# Install Hyprland, Tofi, and Waybar using paru as non-root
echo "Installing Hyprland, Tofi, and Waybar using paru..."
sudo -u "$NON_ROOT_USER" paru -S --noconfirm hyprland-git tofi waybar

# Install additional packages for a smoother experience
echo "Installing additional packages..."
pacman -S --noconfirm wlroots qt5-wayland qt6-wayland xdg-desktop-portal-hyprland

# Copy a sample Hyprland configuration to the user’s config folder if it doesn’t exist
HYPRLAND_CONFIG="$USER_HOME/.config/hypr"
if [ ! -d "$HYPRLAND_CONFIG" ]; then
  mkdir -p "$HYPRLAND_CONFIG"
  cp /usr/share/hyprland/hyprland.conf.example "$HYPRLAND_CONFIG/hyprland.conf"
  chown -R "$NON_ROOT_USER":"$NON_ROOT_USER" "$HYPRLAND_CONFIG"
fi

# Enable user services (e.g., xdg-desktop-portal) for Wayland
echo "Enabling xdg-desktop-portal for Wayland support..."
systemctl --user enable xdg-desktop-portal-hyprland

# Provide instructions for logging into Hyprland
echo
echo "Installation completed successfully!"
echo "To start using Hyprland, log out, and choose SDDM as the display manager."
echo "Then, select Hyprland as your session to log in."
echo
echo "Configure your Hyprland, Waybar, and Tofi settings by editing configuration files in $USER_HOME/.config."
echo "Happy customizing!"
