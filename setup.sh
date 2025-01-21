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
#-- ║ Step 3: Check for Updates on GitHub ║
#-- ╚═══════════════════════╝

repo_url="https://github.com/bnhtho/dotfiles"
local_dir="$home_dir/.dotfiles"
target_branch_or_tag="main"

if [ -d "$local_dir" ]; then
    echo "Checking for updates in the repository..."
    git -C "$local_dir" fetch origin "$target_branch_or_tag"
    # Lấy commit hash của local và remote
    local_commit=$(git -C "$local_dir" rev-parse HEAD)
    remote_commit=$(git -C "$local_dir" rev-parse origin/"$target_branch_or_tag")

    if [ "$local_commit" != "$remote_commit" ]; then
        echo "New updates detected on branch '$target_branch_or_tag'. Re-cloning repository..."
        rm -rf "$local_dir"
        git clone --branch "$target_branch_or_tag" "$repo_url" "$local_dir"
        echo "Repository updated successfully."
    else
        echo "No updates detected. Local repository is up-to-date."
    fi
else
    echo "Cloning your repository (branch/tag: $target_branch_or_tag) to ~/.dotfiles..."
    git clone --branch "$target_branch_or_tag" "$repo_url" "$local_dir"
    echo "Repository cloned successfully."
fi

#-- ╔═══════════════════════╗
#-- ║ Step 4: Update home.nix and flake.nix ║
#-- ╚═══════════════════════╝

home_nix_path="$home_dir/.dotfiles/home.nix"
flake_nix_path="$home_dir/.dotfiles/flake.nix"

# Update flake.nix
if [ -f "$flake_nix_path" ]; then
    echo "Updating flake.nix with current username: $current_user"
    # Update flakeConfigurations block dynamically
    sed -i '' "s|homeConfigurations\..* =|homeConfigurations.\"$current_user\" =|g" "$flake_nix_path"
    # Update description dynamically
    sed -i '' "s|description = \".*\";|description = \"Home Manager configuration of $current_user\";|g" "$flake_nix_path"
    echo "flake.nix updated successfully."
else
    echo "flake.nix not found. Skipping update."
fi

# Update home.nix
if [ -f "$home_nix_path" ]; then
    echo "Updating home.nix with current username: $current_user"
    # Update home.username dynamically
    sed -i '' "s|home\.username = \".*\";|home.username = \"$current_user\";|g" "$home_nix_path"
    # Update home.homeDirectory dynamically
    sed -i '' "s|home\.homeDirectory = \".*\";|home.homeDirectory = \"$home_dir\";|g" "$home_nix_path"
    echo "home.nix updated successfully. Backup created as home.nix.bak"
else
    echo "home.nix not found. Skipping update."
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
elif [ "$machine" == "Linux" ]; then
    echo "Running on Linux"
fi

echo "Setup completed successfully!"
