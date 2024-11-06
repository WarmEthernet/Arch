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

# Install paru (AUR helper) if it's not already installed
echo "Checking for paru..."
if ! command -v paru &> /dev/null; then
  echo "paru not found, installing paru (AUR helper)..."
  pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/paru.git
  cd paru && makepkg -si --noconfirm
  cd ..
  rm -rf paru
fi

# Install Hyprland, Tofi, and Waybar from AUR
echo "Installing Hyprland, Tofi, and Waybar using paru..."
paru -S --noconfirm hyprland-git tofi waybar

# Install additional packages for a smoother experience
echo "Installing additional packages..."
pacman -S --noconfirm wlroots qt5-wayland qt6-wayland xdg-desktop-portal-hyprland

# Copy a sample Hyprland configuration to the user’s config folder if it doesn’t exist
USER_HOME="/home/$(logname)"
HYPRLAND_CONFIG="$USER_HOME/.config/hypr"
if [ ! -d "$HYPRLAND_CONFIG" ]; then
  mkdir -p "$HYPRLAND_CONFIG"
  cp /usr/share/hyprland/hyprland.conf.example "$HYPRLAND_CONFIG/hyprland.conf"
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
