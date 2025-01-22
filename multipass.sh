#!/bin/bash
# Check if Multipass is installed
pkg=$(which multipass)
if [ -z "$pkg" ]; then
    echo "Multipass is not installed on your system."
    curl -L -C - https://github.com/canonical/multipass/releases/download/v1.14.1/multipass-1.14.1+mac-Darwin.pkg --output /tmp/multipass-1.14.1+mac-Darwin.pkg
    sudo installer -pkg /tmp/multipass-1.14.1+mac-Darwin.pkg -target /
else
    echo "Multipass is already installed on your system."
fi

# Wait for Multipass initialization
echo "Waiting for Multipass to initialize..."
while [ ! -S /var/run/multipass_socket ]; do
    sleep 1
done
echo "Multipass is ready."

# Generate SSH key
echo "Generating SSH key..."
ssh-keygen -t rsa -b 4096 -C "$USER" -f multipass-ssh-key -N ""
echo "SSH key generated."

# Copy the public key to clipboard
pbcopy < multipass-ssh-key.pub
echo "Public key copied to clipboard. Paste it when prompted."

# Ask for VM username (will also be used as VM name)
read -p "Enter the name of the host user and VM: " host_user

# Create the `cloud-init` file
cloud_init_file=$(mktemp)
cat <<EOF > "$cloud_init_file"
#cloud-config
users:
  - default
  - name: $host_user
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - $(cat multipass-ssh-key.pub)
EOF

# Create a new Multipass VM with the specified configuration
echo "Creating a new VM named '$host_user'..."
multipass launch 24.04 \
  --name "$host_user" \
  --memory 3G \
  --disk 30G \
  --cloud-init "$cloud_init_file"

# Clean up temporary files
rm "$cloud_init_file"

# Display VM info
echo "Fetching information about the VM '$host_user'..."
multipass info "$host_user"

echo "VM created successfully!"
echo "Your SSH key is stored in 'multipass-ssh-key' and 'multipass-ssh-key.pub'."
echo "To connect to the VM, use:"
echo "  ssh -i multipass-ssh-key $host_user@<VM-IP>"

