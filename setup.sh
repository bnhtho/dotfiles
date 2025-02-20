#!/bin/bash
# =====================
# Installing Dotfiles
# =====================
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
FIREFOX_PKG_URL="https://ftp.mozilla.org/pub/firefox/releases/128.6.0esr/mac/en-US/Firefox%20128.6.0esr.pkg"
PKG_FILE="$HOME/Downloads/Firefox-128.6.0esr.pkg"

if [ -d "/Applications/Firefox.app" ]; then
    echo "Firefox is already installed."
else
    if [ -f "$PKG_FILE" ]; then
        echo "Firefox ESR package already downloaded at $PKG_FILE."
    else
        echo "Downloading Firefox ESR package..."
        curl -L -C - "$FIREFOX_PKG_URL" --output "$PKG_FILE" || { echo "Failed to download Firefox ESR package. Exiting."; exit 1; }
    fi

    echo "Installing Firefox ESR..."
    sudo installer -pkg "$PKG_FILE" -target / || { echo "Failed to install Firefox ESR. Exiting."; exit 1; }
    echo "Firefox ESR has been installed successfully!"
fi

# =====================
# Install ALACRITTY
# =====================
ALACRITTY_DMG_URL="https://github.com/alacritty/alacritty/releases/download/v0.15.0/Alacritty-v0.15.0.dmg"
DMG_FILE="$HOME/Downloads/Alacritty-v0.15.0.dmg"

if [ -d "/Applications/Alacritty.app" ]; then
    echo "Alacritty is already installed."
else
    if [ -f "$DMG_FILE" ]; then
        echo "Alacritty DMG package already downloaded at $DMG_FILE."
    else
        echo "Downloading Alacritty DMG package..."
        curl -L -C - "$ALACRITTY_DMG_URL" --output "$DMG_FILE" || { echo "Failed to download Alacritty DMG package. Exiting."; exit 1; }
    fi

    echo "Mounting Alacritty DMG..."
    hdiutil attach "$DMG_FILE" || { echo "Failed to mount Alacritty DMG. Exiting."; exit 1; }

    echo "Installing Alacritty..."
    cp -R "/Volumes/Alacritty/Alacritty.app" /Applications/

    echo "Ejecting Alacritty DMG..."
    hdiutil detach "/Volumes/Alacritty" || { echo "Failed to eject Alacritty DMG. Exiting."; exit 1; }

    echo "Alacritty has been installed successfully!"
fi

# =====================
# Install GH
# =====================
GH_PKG_URL=$(curl -s "https://api.github.com/repos/cli/cli/releases/latest" | grep "browser_download_url.*macOS.*pkg" | cut -d : -f 2,3 | tr -d '\"' | sed 's/^ //')

if [[ -z "$GH_PKG_URL" ]]; then
    echo "Failed to find download URL for the latest GitHub CLI release. Exiting."
    exit 1
fi

GH_PKG_FILE="$HOME/Downloads/gh_latest_macOS_universal.pkg"

if command -v gh &> /dev/null; then
    echo "GitHub CLI is already installed. Use gh command to execute."
else
    curl -L "$GH_PKG_URL" --output "$GH_PKG_FILE" || { echo "Failed to download GitHub CLI package. Exiting."; exit 1; }

    echo "Installing GitHub CLI..."
    sudo installer -pkg "$GH_PKG_FILE" -target / || { echo "Failed to install GitHub CLI. Exiting."; exit 1; }

    rm "$GH_PKG_FILE"
    echo "GitHub CLI has been installed successfully!"
fi

# =====================
# Install Neovim
# =====================
if command -v nvim &> /dev/null; then
    echo "Neovim is already installed. Use nvim / nvim <file-to-open> command to execute"
else
    cd /tmp
    curl -L -o nvim.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-macos-x86_64.tar.gz" || { echo "Failed to download Neovim. Exiting."; exit 1; }

    tar -xf nvim.tar.gz
    sudo install nvim-macos-x86_64/bin/nvim /usr/local/bin/nvim
    sudo cp -R nvim-macos-x86_64/lib /usr/local/
    sudo cp -R nvim-macos-x86_64/share /usr/local/

    rm -rf nvim-macos-x86_64 nvim.tar.gz
    cd -
    echo "Neovim has been installed successfully!"
fi

# =====================
# Install NVM
# =====================
if ! command -v nvm &> /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    echo "Finished installing nvm. Reopen terminal after finished setup process to install nodes"
fi

# =====================
# Font Install
# =====================
NERD_FONTS_BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
declare -a FONTS=("JetBrainsMono")
FONT_DIR=~/Library/Fonts
DOWNLOAD_DIR=~/Downloads/nerd-fonts

mkdir -p "$DOWNLOAD_DIR"

for font_name in "${FONTS[@]}"; do
    FONT_PATH="$FONT_DIR/$font_name"
    if ls "$FONT_DIR/$font_name"* &>/dev/null; then
        echo "$font_name font is already installed. Skipping installation."
    else
        echo "Installing $font_name font..."
        FONT_URL="$NERD_FONTS_BASE_URL/$font_name.zip"
        FONT_FOLDER="$DOWNLOAD_DIR/$font_name"
        mkdir -p "$FONT_FOLDER"
        FONT_ZIP="$FONT_FOLDER/$font_name.zip"
        curl -L "$FONT_URL" --output "$FONT_ZIP" || { echo "Failed to download $font_name font. Skipping."; continue; }

        unzip -o "$FONT_ZIP" -d "$FONT_FOLDER"
        EXTRACTED_FOLDER=$(find "$FONT_FOLDER" -maxdepth 1 -type d -name "$font_name*")
        if [ -z "$EXTRACTED_FOLDER" ]; then
            echo "Error: No extracted folder found for $font_name. Skipping."
            continue
        fi

        FONT_INSTALL_DIR="$FONT_DIR/$font_name"
        mkdir -p "$FONT_INSTALL_DIR"
        cp -R "$EXTRACTED_FOLDER/"*.ttf "$FONT_INSTALL_DIR/"
        rm -rf "$FONT_ZIP" "$EXTRACTED_FOLDER"
        echo "$font_name has been installed successfully!"
    fi
done

rm -rf "$DOWNLOAD_DIR"

# =====================
# Install Zoxide
# =====================
if command -v zoxide &> /dev/null; then
    echo "zoxide is already installed. Use z command to execute."
else
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.zshrc; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
        echo "Added ~/.local/bin to PATH in .zshrc"
    else
        echo "~/.local/bin is already in your PATH"
    fi

    if ! grep -q 'eval "$(zoxide init zsh)"' ~/.dotfiles/.zshrc; then
        echo 'eval "$(zoxide init zsh)"' >> ~/.dotfiles/.zshrc
        echo "Added Zoxide initialization to .zshrc in dotfiles"
    else
        echo "Zoxide initialization is already in your .zshrc of dotfiles"
    fi
fi

# =====================
# Install FZF
# =====================
TARGET_DIR="/usr/local/bin"
chmod +x "$TARGET_DIR"

if command -v fzf &> /dev/null; then
    echo "fzf is already installed. Use fzf command to execute."
else
    if [ -d "$HOME/.fzf" ]; then
        echo "FZF repository already exists, installing from there..."
    else
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    fi
fi

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
    echo "Yabai is already installed. Using yabai --start-service to running."
else
    curl -L https://raw.githubusercontent.com/koekeishiya/yabai/master/scripts/install.sh | sudo bash /dev/stdin
fi

# =====================
# Install Visual Studio Code
# =====================
VS_CODE_URL="https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal"
TEMP_DIR=$(mktemp -d)
ZIP_FILE="$TEMP_DIR/vscode.zip"
APP_NAME="Visual Studio Code.app"
APP_DEST="/Applications/$APP_NAME"

if [ -d "$APP_DEST" ]; then
  echo "Visual Studio Code is already installed at $APP_DEST."
else
  curl -L "$VS_CODE_URL" -o "$ZIP_FILE" || { echo "Failed to download Visual Studio Code. Exiting."; exit 1; }

  echo "Extracting Visual Studio Code..."
  unzip -q "$ZIP_FILE" -d "$TEMP_DIR" || { echo "Failed to extract Visual Studio Code. Exiting."; exit 1; }

  echo "Moving Visual Studio Code to the Applications folder..."
  mv "$TEMP_DIR/$APP_NAME" "$APP_DEST" || { echo "Failed to move Visual Studio Code. Exiting."; exit 1; }

  rm -rf "$TEMP_DIR"
  echo "Visual Studio Code installed successfully!"
fi

# =====================
# Install skhd
# =====================
REPO_URL="https://github.com/koekeishiya/skhd.git"
INSTALL_DIR="$HOME/skhd"
SYSTEM_BIN_DIR="/usr/local/bin"

if command -v skhd &> /dev/null; then
    echo "skhd is already installed. Using skhd command to execute"
else
    if [ ! -d "$INSTALL_DIR" ]; then
        echo "Cloning skhd repository..."
        git clone "$REPO_URL" "$INSTALL_DIR" || { echo "Failed to clone skhd repository. Exiting."; exit 1; }
    else
        echo "skhd repository already exists. Skipping clone."
    fi

    cd "$INSTALL_DIR" || exit
    echo "Building and installing skhd..."
    make install || { echo "Failed to build and install skhd. Exiting."; exit 1; }

    echo "Copying skhd to $SYSTEM_BIN_DIR..."
    sudo cp "$INSTALL_DIR/bin/skhd" "$SYSTEM_BIN_DIR" || { echo "Failed to copy skhd. Exiting."; exit 1; }

    rm -rf "$INSTALL_DIR"
    echo "skhd installation and configuration completed."
fi

# =====================
# Install Machinna
# =====================
if command -v macchina >/dev/null 2>&1; then
  echo "macchina installed successfully! Use 'macchina' command to execute."
else
  URL="https://github.com/Macchina-CLI/macchina/releases/download/v6.4.0/macchina-v6.4.0-macos-x86_64.tar.gz"
  TEMP_DIR="/tmp/macchina_install"
  TARGET_DIR="/usr/local/bin"
  BINARY_NAME="macchina"

  mkdir -p "$TEMP_DIR" "$TARGET_DIR"

  echo "Downloading macchina..."
  curl -L -o "$TEMP_DIR/macchina.tar.gz" "$URL" || { echo "Failed to download macchina. Exiting."; exit 1; }

  echo "Extracting macchina..."
  tar -xzf "$TEMP_DIR/macchina.tar.gz" -C "$TEMP_DIR" || { echo "Failed to extract macchina. Exiting."; exit 1; }

  echo "Installing macchina to $TARGET_DIR..."
  sudo mv "$TEMP_DIR/$BINARY_NAME" "$TARGET_DIR/" || { echo "Failed to move macchina. Exiting."; exit 1; }

  chmod +x "$TARGET_DIR/$BINARY_NAME"
  rm -rf "$TEMP_DIR"
  echo "macchina installation completed!"
fi

# =====================
# Install Hugo
# =====================
if command -v hugo >/dev/null 2>&1; then
  echo "Hugo already installed successfully! Run 'hugo' to use it."
else
  API_URL="https://api.github.com/repos/gohugoio/hugo/releases/latest"
  ASSET_URL=$(curl -s $API_URL | grep "browser_download_url" | grep "hugo_extended" | grep "darwin-universal.tar.gz" | head -n 1 | cut -d '"' -f 4)

  if [ -z "$ASSET_URL" ]; then
    echo "Error: Could not find the specified asset."
    exit 1
  fi

  TEMP_DIR="/tmp"
  INSTALL_DIR="/usr/local/bin"

  echo "Downloading Hugo from $ASSET_URL..."
  curl -L -o "$TEMP_DIR/hugo_extended.tar.gz" "$ASSET_URL" || { echo "Failed to download Hugo. Exiting."; exit 1; }

  echo "Extracting hugo_extended.tar.gz..."
  tar -xzf "$TEMP_DIR/hugo_extended.tar.gz" -C $TEMP_DIR || { echo "Failed to extract Hugo. Exiting."; exit 1; }

  echo "Installing Hugo to $INSTALL_DIR..."
  sudo mv "$TEMP_DIR/hugo" $INSTALL_DIR || { echo "Failed to move Hugo. Exiting."; exit 1; }

  rm -rf "$TEMP_DIR/hugo_extended.tar.gz" "$TEMP_DIR/hugo"
  echo "Hugo installation completed!"
fi

# =====================
# Install Bat
# =====================
if command -v bat >/dev/null 2>&1; then
  echo "Bat already installed successfully! Run 'bat <file-to-read>' to use it."
else
  API_URL="https://api.github.com/repos/sharkdp/bat/releases/latest"
  ARCH="x86_64"
  ARCH_SUFFIX="x86_64-apple-darwin"

  ASSET_URL=$(curl -s $API_URL | grep "browser_download_url" | grep "$ARCH_SUFFIX" | cut -d '"' -f 4)

  if [ -z "$ASSET_URL" ]; then
    echo "Error: Could not find the latest release for $ARCH_SUFFIX."
    exit 1
  fi

  echo "Downloading from $ASSET_URL..."
  curl -L -o /tmp/bat.tar.gz "$ASSET_URL" || { echo "Failed to download Bat. Exiting."; exit 1; }

  echo "Extracting bat.tar.gz..."
  tar -xzf /tmp/bat.tar.gz -C /tmp || { echo "Failed to extract Bat. Exiting."; exit 1; }

  echo "Installing bat to /usr/local/bin..."
  sudo mv /tmp/bat*/bat /usr/local/bin/ || { echo "Failed to move Bat. Exiting."; exit 1; }

  rm -rf /tmp/bat.tar.gz /tmp/bat*
  echo "Bat installation completed!"
fi