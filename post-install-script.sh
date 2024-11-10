#!/bin/bash

# Cache sudo creds
echo "Please enter your sudo password"
sudo -v

# Set cached sudo creds timeout for the session
sudo sh -c "echo 900 > /proc/$$/limits"

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install prerequisites for building paru
echo "Installing prerequisites..."
sudo pacman -S --needed --noconfirm base-devel git

# Clone repo, build, and install paru
echo "Installing paru AUR helper..."
git clone https://aur.archlinux.org/paru.git
cd paru/
makepkg -si --noconfirm
cd ..
rm -rf paru/
echo "paru installed successfully."

# Install wayland, hyprland, kitty, tofi, and sddm w/dependencies
sudo pacman -S --needed --noconfirm wayland hyprland kitty sddm
paru -S --noconrirm tofi

# Enable sddm
sudo systemctl enable sddm.service

# Reboot
sudo reboot now


