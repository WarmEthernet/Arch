#!/bin/sh

# Update System
sudo pacman -Syu --noconfirm

# Install applications from arch repos
list_of_ar_apps=$(cat <<EOF
alacritty
ansible-core
base-devel
btop
fzf
git
jq
less
lxappearance
lxappearance-obconf
ly
neofetch
nitrogen
obconf
openbox
openssh
picom
python-pip
rofi
rsync
tint2
tmux
tree
unzip
vim
vlc
wget
whois
zsh
EOF
)

sudo pacman -S --noconfirm $list_of_ar_apps

# Install YAY AUR helper
cd /opt
sudo git clone https://aur.archlinux.org/yay.git
sudo chown -R $USER:$USER yay

# Switch to the yay directory and build/install as the normal user
cd /opt/yay
sudo -u $USER makepkg -si --noconfirm
cd ..
rm -rf yay

# Install apps from the AUR
sudo -u $USER yay -S --noconfirm brave-bin obmenu-generator

# Set ly to start
sudo systemctl enable ly.service

# Setup openbox
mkdir -p ~/.config/openbox
cp -a /etc/xdg/openbox ~/.config/
obmenu-generator -u -p -c



