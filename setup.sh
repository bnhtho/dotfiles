#!/bin/bash

#-- ╔═══════════════════════╗
#-- ║    System Detection    ║
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

#-- ╔═══════════════════════╗
#-- ║    Dynamic User Setup  ║
#-- ╚═══════════════════════╝
# Dynamically retrieve the current username
current_user=$(whoami)
home_dir=$(eval echo "~${current_user}")
echo "Current user: ${current_user}"
echo "Home directory: ${home_dir}"

#-- ╔═══════════════════════╗
#-- ║ Step 1: Install Nix   ║
#-- ╚═══════════════════════╝
if ! command -v nix &> /dev/null; then
    echo "Nix is not installed. Installing Nix..."
    curl -L https://nixos.org/nix/install | sh
    echo "Nix installed successfully."
else
    echo "Nix is already installed."
fi

#-- ╔═══════════════════════╗
#-- ║ Step 2: Install Home Manager ║
#-- ╚═══════════════════════╝
if ! nix-channel --list | grep -q 'home-manager'; then
    echo "Adding Home Manager channel..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    echo "Home Manager channel added successfully."
else
    echo "Home Manager channel already exists."
fi

#-- ╔═══════════════════════╗
#-- ║ Step 3: Clone .dotfiles Repo ║
#-- ╚═══════════════════════╝
if [ ! -d "$home_dir/.dotfiles" ]; then
    echo "Cloning your repository to ~/.dotfiles..."
    git clone https://github.com/bnhtho/dotfiles "$home_dir/.dotfiles"
    echo "Repository cloned successfully."
else
    echo ".dotfiles directory already exists. Skipping clone."
fi

#-- ╔═══════════════════════╗
#-- ║ Step 4: Update home.nix and flake.nix ║
#-- ╚═══════════════════════╝
home_nix_path="$home_dir/.dotfiles/home-manager/home.nix"
flake_nix_path="$home_dir/.dotfiles/flake.nix"
if [ -f "$flake_nix_path" ]; then
    echo "Updating flake.nix with current username: $current_user"
    sed -i.bak "s|homeConfigurations\..* =|homeConfigurations.\"$current_user\" =|g" "$flake_nix_path"
    sed -i.bak "s|description = \".*\";|description = \"Home Manager configuration of $current_user\";|g" "$flake_nix_path"
    echo "flake.nix updated successfully."
else
    echo "flake.nix not found. Skipping update."
fi

## - Update home.nix
if [ -f "$home_nix_path" ]; then
    echo "Verifying home.nix..."
    
    # Check for errors in home.nix using nix-instantiate
    if nix-instantiate "$home_nix_path" &>/dev/null; then
        echo "home.nix syntax is valid."
    else
        echo "Error: home.nix contains syntax errors. Please fix them before proceeding."
        exit 1
    fi
else
    echo "home.nix file not found at $home_nix_path. Ensure it exists and is properly configured."
    exit 1
fi

#-- ╔═══════════════════════╗
#-- ║ Step 5: Create Config Directories ║
#-- ╚═══════════════════════╝
echo "Creating necessary directories..."
mkdir -p "$home_dir/.config/nix"
mkdir -p "$home_dir/.config/home-manager"
touch "$home_dir/.config/nix/nix.conf"
echo "Directories and nix.conf created successfully."

#-- ╔═══════════════════════╗
#-- ║ Step 6: Write nix.conf ║
#-- ╚═══════════════════════╝
echo "extra-experimental-features = nix-command flakes" > "$home_dir/.config/nix/nix.conf"
echo "nix.conf content added successfully."

#-- ╔═══════════════════════╗
#-- ║ Step 7: Safely Link Files ║
#-- ╚═══════════════════════╝
echo "Linking .dotfiles to home-manager..."
for dotfile in "$home_dir/.dotfiles"/*; do
    target="$home_dir/.config/home-manager/$(basename "$dotfile")"
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "Symlink already exists for $(basename "$dotfile"). Skipping..."
    else
        ln -s "$dotfile" "$target"
        echo "Created symlink for $(basename "$dotfile")."
    fi
done

#-- ╔═══════════════════════╗
#-- ║ Step 8: Build Configuration ║
#-- ╚═══════════════════════╝
echo "Building configuration..."
if ! nix run home-manager switch; then
    echo "Error: Failed to build configuration. Check your Home Manager setup."
    exit 1
fi

#-- ╔═══════════════════════╗
#-- ║ Step 9: Platform-Specific Actions ║
#-- ╚═══════════════════════╝
if [ "$machine" == "Mac" ]; then
    echo "Running on macOS"
    defaults write com.apple.dock persistent-apps -array
    defaults write com.apple.dock tilesize -integer 36
    killall Dock
    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write -g InitialKeyRepeat -int 10
    defaults write -g KeyRepeat -int 1
elif [ "$machine" == "Linux" ]; then
    echo "Running on Linux"
fi

echo "Setup completed successfully!"
