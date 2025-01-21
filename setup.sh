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


