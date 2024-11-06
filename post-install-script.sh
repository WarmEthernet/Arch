#!/bin/bash

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install prerequisites for building paru
echo "Installing prerequisites..."
sudo pacman -S --needed --noconfirm base-devel git

# Clone paru repository, build, and install it as 'nobody' user
echo "Installing paru AUR helper..."
git clone https://aur.archlinux.org/paru.git
cd paru/
makepkg -si --noconfirm
cd ..
rm -rf paru/
echo "paru installed successfully."


