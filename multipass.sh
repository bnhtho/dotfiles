#!/bin/bash
# Multipass Setup Script for macOS

echo "Setting up Multipass..."

# Check if Multipass is installed
pkg=$(which multipass)
if [ -z "$pkg" ]; then
    echo "Multipass is not installed. Installing..."
    curl -L -C - https://github.com/canonical/multipass/releases/download/v1.14.1/multipass-1.14.1+mac-Darwin.pkg --output /tmp/multipass-1.14.1+mac-Darwin.pkg
    sudo installer -pkg /tmp/multipass-1.14.1+mac-Darwin.pkg -target /
else
    echo "Multipass is already installed."
fi

# Wait for Multipass to initialize
echo "Waiting for Multipass to initialize..."
while [ ! -S /var/run/multipass_socket ]; do
    sleep 1
done

# Get current username
current_user=$(whoami)

# Check if the instance already exists
if multipass list | grep -q "$current_user"; then
    echo "Instance $current_user already exists."
    echo "Please delete it using: multipass delete $current_user --purge"
    exit 0
else
    echo "No existing instance found. Proceeding to create one..."
fi

# Remove existing SSH keys and regenerate
rm -rf ~/.ssh
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""

# Create cloud-init configuration
cloud_init_file="$HOME/primary-config.yaml"
echo "ssh_authorized_keys:" > "$cloud_init_file"
echo "  - $(cat ~/.ssh/id_rsa.pub)" >> "$cloud_init_file"

# Launch the VM
echo "Launching the VM..."
if ! multipass launch 24.04 --name "$current_user" --memory 3G --disk 30G --cloud-init "$cloud_init_file"; then
    echo "Error: Failed to launch the instance."
    exit 1
fi

# Wait for VM to acquire an IP address
echo "Waiting for VM to acquire an IP address..."
while ! multipass info "$current_user" | grep -q "IPv4"; do
    sleep 2
done
ip_address=$(multipass info "$current_user" | grep IPv4 | awk '{print $2}')

# Update SSH configuration
ssh_config_file=~/.ssh/config
if ! grep -q "Host $current_user" "$ssh_config_file"; then
    echo "Updating SSH configuration..."
    cat << EOF >> "$ssh_config_file"
Host $current_user
    HostName $ip_address
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
EOF
fi

# Connect to the instance
echo "VM is ready. Connecting via SSH..."
ssh "$current_user"

echo "Setup complete."
