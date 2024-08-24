#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne "0" ]; then
  echo "This script must be run as root."
  exit 1
fi

# Update System
pacman -Syu --noconfirm

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
xorg-xauth
xorg-server
xorg-xinit
xorg-apps
xfce4-terminal
vim
vlc
wget
whois
zsh
EOF
)

pacman -S --noconfirm --needed $list_of_ar_apps



# Define the default Openbox config directory
DEFAULT_CONFIG_DIR="/etc/xdg/openbox"

# Check if the default config directory exists
if [ ! -d "$DEFAULT_CONFIG_DIR" ]; then
  echo "Default Openbox config directory does not exist: $DEFAULT_CONFIG_DIR"
  exit 1
fi

# Get the home directory of the user who started the script
USER_HOME=$(eval echo ~$SUDO_USER)

# Create the .config directory in the user's home directory
USER_CONFIG_DIR="$USER_HOME/.config/openbox"
mkdir -p "$USER_CONFIG_DIR"

# Copy the default config files to the user's .config/openbox directory
cp -r "$DEFAULT_CONFIG_DIR/"* "$USER_CONFIG_DIR/"

# Set the appropriate ownership for the copied files
chown -R $SUDO_USER:$SUDO_USER "$USER_CONFIG_DIR"

echo "Openbox configuration has been set up in $USER_CONFIG_DIR."




# Setup openbox
#sudo -u $SUDO_USER mkdir -p ~/.config/openbox
#sudo -u $SUDO_USER cp /etc/xdg/openbox/* ~/.config/openbox/
#chown -R $SUDO_USER:$SUDO_USER ~/.config

# Install YAY AUR helper
cd /opt
git clone https://aur.archlinux.org/yay.git
chown -R $SUDO_USER:$SUDO_USER yay

# Switch to the yay directory and build/install as the normal user
cd /opt/yay
sudo -u $SUDO_USER makepkg -si --noconfirm
cd ..
rm -rf yay

# Install apps from the AUR
sudo -u $SUDO_USER yay -S --noconfirm brave-bin obmenu-generator

# Set ly to start
systemctl enable ly.service







