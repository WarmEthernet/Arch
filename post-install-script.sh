#!/bin/bash
set -e

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install prerequisites for building paru
echo "Installing prerequisites..."
sudo pacman -S --needed --noconfirm base-devel git

# Clone paru repository, build, and install it as 'nobody' user
echo "Installing paru AUR helper..."
sudo git clone https://aur.archlinux.org/paru.git /tmp/paru
sudo chown -R nobody:nobody /tmp/paru
cd /tmp/paru
sudo -u nobody makepkg -si --noconfirm
echo "paru installed successfully."

# Install Hyprland, Wayland, and SDDM
echo "Installing Hyprland, Wayland, and SDDM..."
paru -S --noconfirm wayland hyprland sddm

# Enable SDDM to start at boot
echo "Enabling SDDM service..."
sudo systemctl enable sddm.service

# Configure SDDM to start Hyprland by default
echo "Configuring SDDM to use Hyprland..."
sddm_config_dir="/etc/sddm.conf.d"
sddm_config_file="$sddm_config_dir/wayland.conf"

# Create SDDM config directory if it doesn't exist
sudo mkdir -p "$sddm_config_dir"

# Write configuration to select Hyprland as the session
echo -e "[General]\nSession=hyprland" | sudo tee "$sddm_config_file" > /dev/null

echo "SDDM configured to use Hyprland as the default session."

# Cleanup
echo "Cleaning up..."
sudo rm -rf /tmp/paru

echo "Post-installation setup completed successfully."
