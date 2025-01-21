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
echo "Directories created successfully."

# Step 5 - Copy nix.conf to ~/.config/nix
MARKER_FILE="/tmp/nix_conf_copied"
if [ ! -f "$MARKER_FILE" ]; then
    echo "Copying nix.conf to ~/.config/nix..."
    cp -r ~/.dotfiles/nix/ ~/.config/nix/
    echo "nix.conf copied successfully."

    # Create marker file to prevent future copies in this session
    touch "$MARKER_FILE"
else
    echo "nix.conf has already been copied in this session. Skipping..."
fi

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
