#!/bin/bash

#-- ╔═══════════════════════╗
#-- ║ Step 11: Multipass    ║
#-- ╚═══════════════════════╝

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
