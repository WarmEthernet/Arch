#!/bin/bash

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

# Install wayland, hyprland, kitty, wofi, and sddm w/dependencies
sudo pacman -S --needed --noconfirm wayland hyprland kitty sddm wofi

# Enable sddm
sudo systemctl enable sddm.service

# Reboot
sudo reboot now


