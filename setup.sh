#!/bin/bash

#-- ╔═══════════════════════╗
#-- ║    Variables          ║
#-- ╚═══════════════════════╝

current_user=$(whoami) 
home_dir=$(eval echo "~${current_user}")
echo "Current user: ${current_user}"
echo "Home directory: ${home_dir}"

#-- ╔═════════════════════════════╗
#-- ║ Check for Updates on GitHub ║
#-- ╚═════════════════════════════╝

repo_url="https://github.com/bnhtho/dotfiles"
local_dir="$home_dir/.dotfiles"
config_dir="$home_dir/.config"
target_branch_or_tag="main"

# Kiểm tra nếu thư mục ~/.dotfiles đã tồn tại
if [ -d "$local_dir" ]; then
    echo "Checking for updates in the repository..."
    git -C "$local_dir" fetch origin "$target_branch_or_tag"
    
    # Lấy commit hash của local và remote
    local_commit=$(git -C "$local_dir" rev-parse HEAD)
    remote_commit=$(git -C "$local_dir" rev-parse origin/"$target_branch_or_tag")
    
    if [ "$local_commit" != "$remote_commit" ]; then
        echo "New updates detected on branch '$target_branch_or_tag'."
        
        # Hiển thị log thay đổi
        echo "Changes since last update:"
        git -C "$local_dir" log --oneline "$local_commit..$remote_commit"
        
        # Xóa thư mục ~/.dotfiles và ~/.config trước khi re-clone
        echo "Removing existing ~/.config and ~/.dotfiles directories..."
        rm -rf "$config_dir" "$local_dir"
        echo "Directories ~/.config and ~/.dotfiles removed successfully."
        
        # Clone lại repository
        echo "Cloning repository..."
        git clone --branch "$target_branch_or_tag" "$repo_url" "$local_dir"
        echo "Repository updated successfully."
    else
        echo "No updates detected. Local repository is up-to-date."
    fi
else
    # Nếu thư mục ~/.dotfiles không tồn tại, tiến hành clone mới
    echo "Cloning repository (branch/tag: $target_branch_or_tag) to ~/.dotfiles..."
    git clone --branch "$target_branch_or_tag" "$repo_url" "$local_dir"
    echo "Repository cloned successfully."
fi

# Đảm bảo thư mục ~/.config được tạo lại
echo "Recreating ~/.config directory..."
mkdir -p "$config_dir"
echo "~/.config directory created successfully."
# ---

#-- ╔═══════════════════════╗
#-- ║    System Detection   ║
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
if [ "$machine" == "Mac" ]; then
# --------------------------------------- MacOS ----------------------
echo "Starting Installation for MacOS"
#-- ╔═══════════════════════════════╗
#-- ║ Update home.nix and flake.nix ║
#-- ╚═══════════════════════════════╝

home_nix_path="$home_dir/.dotfiles/home.nix"
flake_nix_path="$home_dir/.dotfiles/flake.nix"

# ---- Flake.nix ----
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
# ---- Home.nix -----
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
#-- ║    Config file        ║
#-- ╚═══════════════════════╝

home_dir=$(eval echo "~${current_user}")

echo "Creating necessary directories..."
mkdir -p "$home_dir/.config/nix"
mkdir -p "$home_dir/.config/home-manager"
touch "$home_dir/.config/nix/nix.conf"
echo "Directories and nix.conf created successfully."

## Add content of file config to ~/.config/nix
echo "extra-experimental-features = nix-command flakes" > "$home_dir/.config/nix/nix.conf"
echo "nix.conf content added successfully."

#-- ╔═══════════════════════╗
#-- ║     Cleanup & Symlink ║
#-- ╚═══════════════════════╝

echo "Cleaning up existing symlinks in ~/.config/home-manager..."
for existing_symlink in "$home_dir/.config/home-manager/"*; do
    if [ -L "$existing_symlink" ]; then
        rm "$existing_symlink"
        echo "Removed symlink: $(basename "$existing_symlink")."
    fi
done

echo "Linking .dotfiles to home-manager..."
for dotfile in "$home_dir/.dotfiles"/*; do
    target="$home_dir/.config/home-manager/$(basename "$dotfile")"
    ln -s "$dotfile" "$target"
    echo "Created symlink for $(basename "$dotfile")."
done

echo "Setup completed successfully."


#-- ╔═══════════════════════╗
#-- ║       Build           ║
#-- ╚═══════════════════════╝
echo "Building configuration..."
if ! nix run home-manager switch; then
    echo "Error: Failed to build configuration. Check your Home Manager setup."
    exit 1
fi
# Install Neovim-related libraries
yarn global add @olrtg/emmet-language-server
yarn global add typescript-language-server typescript

## Finish
ln -s ~/.nix-profiles/applications ~/Applications
elif [ "$machine" == "Linux" ]; then
echo "Dotfiles for Ubuntu"
# --------------------------------------- Linux ---------------------
echo "Updating system packages..."
sudo apt-get dist-upgrade -y
sudo apt-get update

echo "Installing package manager dependencies..."
sudo apt-get install build-essential curl zip unzip gcc fasd ripgrep -y

echo "Installing Homebrew..."
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Configure Homebrew for Linux
  if [ -d ~/.linuxbrew ]; then
    eval "$(~/.linuxbrew/bin/brew shellenv)"
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
  elif [ -d /home/linuxbrew/.linuxbrew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
  fi
else
  echo "Homebrew is already installed."
fi

# Reload bashrc
source ~/.bashrc

echo "Installing packages with Homebrew..."
brew install neovim
brew install git
brew install gh
brew install fastfetch
brew install btop
brew install lazygit
brew install fnm
brew install fzf
# brew install ripgrep

# Symlink Neovim configuration
echo "Creating symlink for Neovim..."
ln -s ~/.dotfiles/config/nvim ~/.config/nvim
# Install and use Node.js LTS version
echo "Adding FNM configuration to .bashrc..."
if ! grep -q 'eval "$(fnm env --use-on-cd --shell bash)"' ~/.bashrc; then
  echo 'eval "$(fnm env --use-on-cd --shell bash)"' >> ~/.bashrc
fi

echo "Installing and using Node.js LTS (22.13.0) with FNM..."
fnm install 22.13.0
fnm use 22.13.0
echo "Sourcing Bashrc"
source ~/.bashrc
echo "Setup completed!"

fi
