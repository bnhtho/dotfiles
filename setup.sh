#!/bin/bash
#-- ╔═══════════════════════╗
#-- ║    System             ║
#-- ╚═══════════════════════╝
# Detect the operating system
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "Detected platform: ${machine}"

# Step 1 - Install Nix
if ! command -v nix &> /dev/null; then
    echo "Nix is not installed. Installing Nix..."
    curl -L https://nixos.org/nix/install | sh
    echo "Nix installed successfully."
else
    echo "Nix is already installed."
fi

# Step 2 - Install Home Manager
if ! nix-channel --list | grep -q 'home-manager'; then
    echo "Adding Home Manager channel..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    echo "Home Manager channel added successfully."
else
    echo "Home Manager channel already exists."
fi

# Step 3 - Clone your repo and rename it to .dotfiles
if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Cloning your repository to ~/.dotfiles..."
    git clone https://github.com/bnhtho/dotfiles ~/.dotfiles
    echo "Repository cloned successfully."
else
    echo ".dotfiles directory already exists. Skipping clone."
fi

# Step 4 - Create ~/.config and ~/.config/nix and home-manager directory
echo "Creating necessary directories..."
mkdir -p ~/.config/nix
mkdir -p ~/.config/home-manager
touch ~/.config/nix/nix.conf

echo "Directories and nix.conf created successfully."
echo "Step 5: Create file"
# Step 5 - Writing to nix.conf
    echo "extra-experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    echo "nix.conf content added successfully."

# Step 6 - Link .dotfiles to home-manager (symlink the content)
echo "Linking .dotfiles to home-manager..."
for dotfile in ~/.dotfiles/*; do
    if [ -d "$dotfile" ]; then
        ln -s "$dotfile" ~/.config/home-manager/$(basename "$dotfile")
    elif [ -f "$dotfile" ]; then
        ln -s "$dotfile" ~/.config/home-manager/$(basename "$dotfile")
    fi
done

# Step 7 - Run the script
echo "Building configuration..."
nix run home-manager switch

# Platform-specific actions
#-- ╔═══════════════════════╗
#-- ║    Mac                ║
#-- ╚═══════════════════════╝
if [ "$machine" == "Mac" ]; then
    echo "Running on macOS"
    
    # Check current hostname
    currentHostName=$(scutil --get HostName 2>/dev/null)
    if [ "$currentHostName" == "MacbookAir" ]; then
        echo "Hostname is already set to 'MacbookAir'. No changes needed."
    else
        echo "Setting hostname to 'MacbookAir'..."
        sudo scutil --set HostName MacbookAir
        echo "Hostname updated successfully."
    fi
#-- ╔═══════════════════════╗
#-- ║    Linux              ║
#-- ╚═══════════════════════╝
elif [ "$machine" == "Linux" ]; then
    echo "Running on Linux"
    # Add Linux-specific code here if needed
fi

#-- ╔═══════════════════════╗
#-- ║    Services           ║
#-- ╚═══════════════════════╝
# Function to check and manage a service
manage_service() {
  service_name="$1"

  # Check if the service is running using ps aux
  if ps aux | grep -v grep | grep -q "$service_name"; then
    echo "$service_name service is already running. Restarting..."
    "$service_name" --restart-service
  else
    echo "$service_name service is not running. Starting..."
    "$service_name" --start-service
  fi
}

# Manage yabai and skhd services
manage_service "yabai"
manage_service "skhd" 

## Add other tweaks for macOS
echo "Disable all default Icons of the dock and make dozer size to 36"
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock tilesize -integer 36
killall Dock

echo "Disable hold to show accents"
defaults write -g ApplePressAndHoldEnabled -bool false
echo "Optimize key speed"
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

