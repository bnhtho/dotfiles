#!/bin/bash
#-- ╔═══════════════════════╗
#-- ║    Dynamic Variables  ║
#-- ╚═══════════════════════╝
# Variables for dynamic username and home directory
USERNAME=$(whoami)
HOMEDIR=$(eval echo ~"$USERNAME")

# Path to the home.nix file
HOME_NIX_FILE="./home.nix"
echo "Looking for home.nix at: $HOME_NIX_FILE"

# Replace placeholders dynamically
if [ -f "$HOME_NIX_FILE" ]; then
    echo "Updating $HOME_NIX_FILE with dynamic variables..."
    sed -i.bak -e "s|__USERNAME__|$USERNAME|g" \
               -e "s|__HOMEDIR__|$HOMEDIR|g" \
               "$HOME_NIX_FILE"
    echo "Dynamic variables injected into $HOME_NIX_FILE."
    
    # Output the username and home directory with emojis
    echo "Home-manager will config on : 🖥️  $USERNAME"
    echo "Home Directory: 📁  $HOMEDIR"
else
    echo "Error: $HOME_NIX_FILE does not exist."
    exit 1
fi


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

# Marker file to track whether nix.conf has already been copied
MARKER_FILE="/tmp/nix_conf_copied"

# Check and copy nix.conf only once
if [ ! -f "$MARKER_FILE" ]; then
    echo "Copying nix.conf to ~/.config folder..."
    mkdir -p ~/.config/nix
    cp ~/.dotfiles/nix/nix.conf ~/.config/nix/
    echo "Nix configuration copied successfully."

    # Create marker file
    touch "$MARKER_FILE"
else
    echo "nix.conf has already been copied in this session. Skipping..."
fi

# -------------------------------------------------------------------------
# Run update
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
