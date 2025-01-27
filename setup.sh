#!/bin/bash
# =====================
# Installing Dotfiles
# =====================
#!/bin/bash
git clone https://github.com/bnhtho/dotfiles ~/.dotfiles
# Define source and destination
SRC_DIR="$HOME/.dotfiles"
DEST_DIR="$HOME"

# Files to copy
FILES_TO_COPY=(
  ".gitconfig"
  ".zshrc"
)

# Directories to symlink
DIRS_TO_SYMLINK=(
  ".config"
)

# Copy files
for FILE in "${FILES_TO_COPY[@]}"; do
  SRC="$SRC_DIR/$FILE"
  DEST="$DEST_DIR/$FILE"

  echo "Copying $SRC to $DEST"
  cp "$SRC" "$DEST"
done

# Create symlinks
for DIR in "${DIRS_TO_SYMLINK[@]}"; do
  SRC="$SRC_DIR/$DIR"
  DEST="$DEST_DIR/$DIR"

  echo "Creating symlink from $SRC to $DEST"
  ln -snf "$SRC" "$DEST"
done

echo "Dotfiles setup completed!"

# =====================
# Install Firefox
# =====================

# Define the URL for the latest Firefox ESR `.pkg` version
FIREFOX_PKG_URL="https://ftp.mozilla.org/pub/firefox/releases/128.6.0esr/mac/en-US/Firefox%20128.6.0esr.pkg"
PKG_FILE="$HOME/Downloads/Firefox-128.6.0esr.pkg"

# Check if Firefox is already installed
if [ -d "/Applications/Firefox.app" ]; then
    echo "Firefox is already installed. Skipping installation."
else
    # Check if the Firefox ESR `.pkg` is already downloaded
    if [ -f "$PKG_FILE" ]; then
        echo "Firefox ESR package already downloaded at $PKG_FILE."
    else
        echo "Downloading Firefox ESR package..."
        curl -L -C - "$FIREFOX_PKG_URL" --output "$PKG_FILE"

        if [[ $? -ne 0 ]]; then
            echo "Failed to download Firefox ESR package. Exiting."
        fi
    fi

    # Install the `.pkg` file
    echo "Installing Firefox ESR..."
    sudo installer -pkg "$PKG_FILE" -target /

    if [[ $? -ne 0 ]]; then
        echo "Failed to install Firefox ESR. Exiting."
    fi
    echo "Firefox ESR has been installed successfully!"
fi


# =====================
# Install ALACRITTY
# =====================


# Define the URL for the latest Alacritty `.dmg` file
ALACRITTY_DMG_URL="https://github.com/alacritty/alacritty/releases/download/v0.15.0/Alacritty-v0.15.0.dmg"
DMG_FILE="$HOME/Downloads/Alacritty-v0.15.0.dmg"

# Check if Alacritty is already installed
if [ -d "/Applications/Alacritty.app" ]; then
    echo "Alacritty is already installed. Skipping installation."
else
    # Check if the Alacritty `.dmg` is already downloaded
    if [ -f "$DMG_FILE" ]; then
        echo "Alacritty DMG package already downloaded at $DMG_FILE."
    else
        echo "Downloading Alacritty DMG package..."
        curl -L -C - "$ALACRITTY_DMG_URL" --output "$DMG_FILE"

        if [[ $? -ne 0 ]]; then
            echo "Failed to download Alacritty DMG package. Exiting."
        fi
    fi

    # Mount the `.dmg` file
    echo "Mounting Alacritty DMG..."
    hdiutil attach "$DMG_FILE"

    # Check if mounting was successful
    if [[ $? -ne 0 ]]; then
        echo "Failed to mount Alacritty DMG. Exiting."
    fi

    # Install Alacritty by copying it to /Applications
    echo "Installing Alacritty..."
    cp -R "/Volumes/Alacritty/Alacritty.app" /Applications/

    # Eject the DMG
    echo "Ejecting Alacritty DMG..."
    hdiutil detach "/Volumes/Alacritty"

    if [[ $? -ne 0 ]]; then
        echo "Failed to eject Alacritty DMG. Exiting."
        
    fi

    echo "Alacritty has been installed successfully!"
fi


# =====================
# Install GH
# =====================


# Fetch the latest GitHub CLI release URL for macOS (Universal .pkg)
GH_PKG_URL=$(curl -s "https://api.github.com/repos/cli/cli/releases/latest" \
    | grep "browser_download_url.*macOS.*pkg" \
    | cut -d : -f 2,3 \
    | tr -d '\"' \
    | sed 's/^ //')  # Remove any leading spaces

# Check if the URL was fetched correctly
if [[ -z "$GH_PKG_URL" ]]; then
    echo "Failed to find download URL for the latest GitHub CLI release. Exiting."
    
fi

# Define the output path for the downloaded `.pkg` file
GH_PKG_FILE="$HOME/Downloads/gh_latest_macOS_universal.pkg"

# Check if GH CLI is already installed
if command -v gh &> /dev/null; then
    echo "GitHub CLI is already installed. Skipping installation."
else
    # Download the GitHub CLI .pkg file
    echo "Downloading GitHub CLI from $GH_PKG_URL..."
    curl -L "$GH_PKG_URL" --output "$GH_PKG_FILE"

    # Check if the download was successful
    if [[ $? -ne 0 ]]; then
        echo "Failed to download GitHub CLI package. Exiting."
        
    fi

    # Install the .pkg file
    echo "Installing GitHub CLI..."
    sudo installer -pkg "$GH_PKG_FILE" -target /

    # Clean up the downloaded .pkg file
    rm "$GH_PKG_FILE"

    echo "GitHub CLI has been installed successfully!"
fi


# =====================
# Install Neovim
# =====================


# Check if Neovim is already installed
if command -v nvim &> /dev/null; then
    echo "Neovim is already installed. Skipping installation."
else
    echo "Installing Neovim"
    # Navigate to /tmp directory
    cd /tmp

    # Download the macOS version of Neovim
   curl -L -o nvim.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-macos-x86_64.tar.gz"


    # Extract the downloaded tar.gz file
    tar -xf nvim.tar.gz

    # Install the nvim binary to /usr/local/bin
    sudo install nvim-macos-x86_64/bin/nvim /usr/local/bin/nvim

    # Copy libraries and share files (macOS may require these paths)
    sudo cp -R nvim-macos-x86_64/lib /usr/local/
    sudo cp -R nvim-macos-x86_64/share /usr/local/

    # Clean up
    rm -rf nvim-macos-x86_64 nvim.tar.gz

    # Return to the original directory
    cd -

    echo "Neovim has been installed successfully!"
fi

# =====================
# Install NVM
# =====================
echo "Install Node Package Manager"

# Check if script installed
if command -v nvm &> /dev/null; then
    echo "Nvm is already installed. Skipping installation."
else
    # Download the macOS version of nvm
   	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

	echo "Finished installing nvm. Reopen terminal after finished seturjjp.sh process to install nodes"
	
	## source ~/bashrc
    cd ~/.
fi


# =====================
# Font Install
# =====================


# Base URL for Nerd Fonts GitHub releases
NERD_FONTS_BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"

# List of fonts to install (only font names)
declare -a FONTS=("JetBrainsMono")  # Add more font names here

FONT_DIR=~/Library/Fonts
DOWNLOAD_DIR=~/Downloads/nerd-fonts

# Function to check if a font is installed
is_font_installed() {
    local font_name="$1"
    if ls "$FONT_DIR/$font_name"* &>/dev/null; then
        return 0  # Font is installed
    else
        return 1  # Font is not installed
    fi
}

# Create the Nerd Fonts download base directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"

# Install fonts dynamically
for font_name in "${FONTS[@]}"; do
    FONT_PATH="$FONT_DIR/$font_name"

    if is_font_installed "$font_name"; then
        echo "$font_name font is already installed. Skipping installation."
    else
        echo "Installing $font_name font..."

        # Construct the download URL based on the font name
        FONT_URL="$NERD_FONTS_BASE_URL/$font_name.zip"

        # Create a separate folder for the font in ~/Downloads/nerd-fonts
        FONT_FOLDER="$DOWNLOAD_DIR/$font_name"
        mkdir -p "$FONT_FOLDER"

        # Download the font zip file to the specific font folder
        FONT_ZIP="$FONT_FOLDER/$font_name.zip"
        curl -L "$FONT_URL" --output "$FONT_ZIP"

        # Unzip the font into its respective folder
        unzip -o "$FONT_ZIP" -d "$FONT_FOLDER"
        
        # Find the correct subfolder after extraction (if it exists)
        EXTRACTED_FOLDER=$(find "$FONT_FOLDER" -maxdepth 1 -type d -name "$font_name*")
        
        # Check if we found the extracted folder
        if [ -z "$EXTRACTED_FOLDER" ]; then
            echo "Error: No extracted folder found for $font_name. Skipping."
            continue
        fi
        
        # Create a subdirectory in ~/Library/Fonts for each font
        FONT_INSTALL_DIR="$FONT_DIR/$font_name"
        mkdir -p "$FONT_INSTALL_DIR"

        # Copy font files into this directory
        cp -R "$EXTRACTED_FOLDER/"*.ttf "$FONT_INSTALL_DIR/"
        
        # Clean up the downloaded zip and extracted files
        rm -rf "$FONT_ZIP" "$EXTRACTED_FOLDER"
        
        # Rebuild the font cache
  

        echo "$font_name has been installed successfully!"
    fi
done

# =====================
# Install Zoxide
# =====================


echo "Setup Zoxide"

# Check if Zoxide is already installed
if command -v zoxide &> /dev/null; then
    echo "zoxide is already installed. Skipping installation."
else
    # Install Zoxide if it's not found
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# Add ~/.local/bin to $PATH in .zshrc if it's not already there
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.zshrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    echo "Added ~/.local/bin to PATH in .zshrc"
else
    echo "~/.local/bin is already in your PATH"
fi

# Add Zoxide initialization to .zshrc if it's not already there
if ! grep -q 'eval "$(zoxide init zsh)"' ~/.dotfiles/.zshrc; then
    echo 'eval "$(zoxide init zsh)"' >> ~/.dotfiles/.zshrc
    echo "Added Zoxide initialization to .zshrc in dotfiles"
else
    echo "Zoxide initialization is already in your .zshrc of dotfiles"
fi

# =====================
# Install FZF
# =====================

echo "Installing FZF"

# Check if FZF is already installed
if command -v fzf &> /dev/null; then
    echo "fzf is already installed. Skipping installation."
else
    # Install fzf if it's not found
    if [ -d "$HOME/.fzf" ]; then
        echo "FZF repository already exists, installing from there..."
    else
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi
    ~/.fzf/install
fi

# Add FZF initialization to .zshrc if it's not already there
if ! grep -q 'source <(fzf --zsh)' ~/.dotfiles/.zshrc; then
    echo 'source <(fzf --zsh)' >> ~/.dotfiles/.zshrc
    echo "Added fzf initialization to .zshrc in dotfiles"
else
    echo "fzf initialization is already in your .zshrc of dotfiles"
fi

# =====================
# Install Yabai
# =====================

if command -v yabai &> /dev/null; then
    echo "Yabai installed ! Skip."
else
    # Install yabai if it's not found
curl -L https://raw.githubusercontent.com/koekeishiya/yabai/master/scripts/install.sh | sh /dev/stdin
fi

#!/bin/bash

# =====================
# Install Visual Studio Code
# =====================

# Define the URL, temporary download location, and target application path
VS_CODE_URL="https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal"
TEMP_DIR=$(mktemp -d)
ZIP_FILE="$TEMP_DIR/vscode.zip"
APP_NAME="Visual Studio Code.app"
APP_DEST="/Applications/$APP_NAME"

# Check if Visual Studio Code is already installed
if [ -d "$APP_DEST" ]; then
  echo "Visual Studio Code is already installed at $APP_DEST."
else
  # Download the zip file
  echo "Downloading Visual Studio Code..."
  curl -L "$VS_CODE_URL" -o "$ZIP_FILE"

  # Extract the zip file
  echo "Extracting Visual Studio Code..."
  unzip -q "$ZIP_FILE" -d "$TEMP_DIR"

  # Move the .app to the Applications folder
  echo "Moving Visual Studio Code to the Applications folder..."
  mv "$TEMP_DIR/$APP_NAME" "$APP_DEST"

  # Clean up
  echo "Cleaning up..."
  rm -rf "$TEMP_DIR"

  echo "Visual Studio Code installed successfully!"
fi

# =====================
# Install skhd
# =====================

# Define the repository URL and installation path
REPO_URL="https://github.com/koekeishiya/skhd.git"
INSTALL_DIR="$HOME/skhd"
SYSTEM_BIN_DIR="/usr/local/bin"

# Check if skhd is already installed
if command -v skhd &> /dev/null; then
    echo "skhd is already installed. Skipping installation."
else
    # Clone the repository if it's not already there
    if [ ! -d "$INSTALL_DIR" ]; then
        echo "Cloning skhd repository..."
        git clone "$REPO_URL" "$INSTALL_DIR"
    else
        echo "skhd repository already exists. Skipping clone."
    fi

    # Enter the skhd directory
    cd "$INSTALL_DIR" || exit

    # Build and install skhd
    echo "Building and installing skhd..."
    make install

   
    # Check if /usr/local/bin exists, and if not, attempt to create it
    if [ ! -d "$SYSTEM_BIN_DIR" ]; then
        echo "/usr/local/bin does not exist. Creating it..."
        sudo mkdir -p "$SYSTEM_BIN_DIR"
        sudo chown $(whoami):$(whoami) "$SYSTEM_BIN_DIR"
    fi

    # Copy skhd to /usr/local/bin for global access
	if [ ! -f "$SYSTEM_BIN_DIR/skhd" ]; then
    echo "Copying skhd to $SYSTEM_BIN_DIR..."
    sudo cp "$INSTALL_DIR/skhd" "$SYSTEM_BIN_DIR/skhd"
	else
    echo "skhd is already in $SYSTEM_BIN_DIR."
	fi

    echo "skhd installation and configuration completed."
fi


# =====================
# Install and Run Machinna
# =====================
#!/bin/bash

# Define variables
URL="https://github.com/Macchina-CLI/macchina/releases/download/v6.4.0/macchina-v6.4.0-macos-x86_64.tar.gz"
TEMP_DIR="/tmp/macchina_install"
TARGET_DIR="/usr/local/bin"
BINARY_NAME="macchina"

# Create necessary directories
mkdir -p "$TEMP_DIR" "$TARGET_DIR"

# Download macchina
echo "Downloading macchina..."
curl -L -o "$TEMP_DIR/macchina.tar.gz" "$URL"

# Extract the tar.gz
echo "Extracting macchina..."
tar -xzf "$TEMP_DIR/macchina.tar.gz" -C "$TEMP_DIR"

# Move the binary to the local bin directory
echo "Installing macchina to $TARGET_DIR..."
sudo mv "$TEMP_DIR/$BINARY_NAME" "$TARGET_DIR/"

# Make it executable
echo "Setting executable permissions..."
chmod +x "$TARGET_DIR/$BINARY_NAME"


# Clean up
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

# Verify installation
if command -v macchina >/dev/null 2>&1; then
  echo "macchina installed successfully! Run 'macchina' to use it."
else
  echo "Installation failed. Please check the steps."
fi
