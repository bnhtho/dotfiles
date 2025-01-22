#!/bin/bash

#-- ╔═══════════════════════╗
#-- ║    Variables.         ║
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
echo ("Starting Installation for MacOS") 
#-- ╔═══════════════════════╗
#-- ║ Install Nix           ║
#-- ╚═══════════════════════╝
if ! command -v nix &> /dev/null; then
    echo "Nix is not installed. Installing Nix..."
    curl -L https://nixos.org/nix/install | sh
    echo "Nix installed successfully."
else
    echo "Nix is already installed."
fi

#-- ╔══════════════════════════════╗
#-- ║ Install Home Manager         ║
#-- ╚══════════════════════════════╝
if ! nix-channel --list | grep -q 'home-manager'; then
    echo "Adding Home Manager channel..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    echo "Home Manager channel added successfully."
else
    echo "Home Manager channel already exists."
fi

#-- ╔══════════════════════════════╗
#-- ║ Install Home Manager         ║
#-- ╚══════════════════════════════╝
if ! nix-channel --list | grep -q 'home-manager'; then
    echo "Adding Home Manager channel..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    echo "Home Manager channel added successfully."
else
    echo "Home Manager channel already exists."
fi


#-- ╔═══════════════════════════════╗
#-- ║ Update home.nix and flake.nix ║
#-- ╚═══════════════════════════════╝

home_nix_path="$home_dir/.dotfiles/home.nix"
flake_nix_path="$home_dir/.dotfiles/flake.nix"

#--- Update flake.nix
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
# ---- Home.nix ---
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

echo "Creating necessary directories..."
mkdir -p "$home_dir/.config/nix"
mkdir -p "$home_dir/.config/home-manager"
touch "$home_dir/.config/nix/nix.conf"
echo "Directories and nix.conf created successfully."

## Add content of file config to ~/.config/nix
echo "extra-experimental-features = nix-command flakes" > "$home_dir/.config/nix/nix.conf"
echo "nix.conf content added successfully.

#-- ╔═══════════════════════╗
#-- ║     Symlink.          ║
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
#-- ║       Build           ║
#-- ╚═══════════════════════╝
echo "Building configuration..."
if ! nix run home-manager switch; then
    echo "Error: Failed to build configuration. Check your Home Manager setup."
    exit 1
fi


#-- ╔═══════════════════════╗
#-- ║ Neovim                ║
#-- ╚═══════════════════════╝
# NOTE: Requirement for Neovim: ban (MacOS)
# Check if fnm, node, and npm are installed
if command -v fnm > /dev/null && command -v node > /dev/null && command -v npm > /dev/null; then
  echo "fnm, Node.js, and npm are installed. Proceeding with library installation..."
  
  # Run the installation command
  yarn global add @olrtg/emmet-language-server
  yarn global add typescript-language-server typescript
  if [ $? -eq 0 ]; then

    echo "Library installed successfully!"
  else
    echo "An error occurred while installing the library."
  fi
else
  echo "fnm, Node.js, or npm is not installed. Please check your environment."
fi



#-- ╔═══════════════════════╗
#-- ║ Multipass             ║
#-- ╚═══════════════════════╝

# NOTE: Create Ubuntu Instance 
# Ubuntu:24.04 LTS
# Instance Name : Username

echo "Setup Multipass"

# Check if multipass is setup already?
pkg=$(which multipass)
if [ -z "$pkg" ]; then
    echo "Multipass is not installed on your system."
    curl -L -C - https://github.com/canonical/multipass/releases/download/v1.14.1/multipass-1.14.1+mac-Darwin.pkg --output /tmp/multipass-1.14.1+mac-Darwin.pkg
    sudo installer -pkg /tmp/multipass-1.14.1+mac-Darwin.pkg -target /
else
    echo "Multipass is already installed on your system."
fi

# Wait for Multipass start
echo "Waiting for Multipass to initialize..."
while [ ! -S /var/run/multipass_socket ]; do
    sleep 1
done
 
# Get the current username
current_user=$(whoami)

## Delete .ssh
rm -r -f ~/.ssh
echo "Multipass is ready. Checking for existing instance..."

# Check if the instance already exists
if multipass list | grep -q "$current_user"; then
    echo "Instance $current_user already exists. Deleting the old instance..."
    multipass delete "$current_user" --purge
else
    echo "No existing instance found."
fi

# Launch a new instance
echo "Creating new instance..."
# Check for SSH key and create the configuration
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "SSH key not found, generating one..."
    ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
fi

# Create the cloud-init YAML file
echo "Creating cloud-init configuration..."
echo -n -e "ssh_authorized_keys:\n  - " > ~/"primary-config.yaml"
cat ~/.ssh/id_rsa.pub >> ~/"primary-config.yaml"

# Launch the VM with the configuration
echo "Launching the VM with cloud-init..."
multipass launch 24.04 --name "$current_user" --memory 3G --disk 30G --cloud-init ~/"primary-config.yaml"

# Check the status of the VM
echo "Waiting for the VM to start..."
while ! multipass info "$current_user" | grep -q "Running"; do
    sleep 1
done
echo "VM is ready."

# Update SSH config for easy access
echo "Configuring SSH for easier access..."
cat << EOF >> ~/.ssh/config
Host $current_user
    HostName $(multipass info "$current_user" | grep IPv4 | awk '{print $2}')
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
EOF

# Display all Multipass VMs
ssh $current_user

echo ("Finished for MacOS Installation") 
elif [ "$machine" == "Linux" ]; then
echo("Dotfiles for Ubuntu")
# --------------------------------------- Linux ----------------------

fi
