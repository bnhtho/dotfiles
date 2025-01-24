#-- ╔═══════════════════════╗
#-- ║ Firefox Installing    ║
#-- ╚═══════════════════════╝
# Define the URL for the latest Firefox ESR `.pkg` version
FIREFOX_PKG_URL="https://ftp.mozilla.org/pub/firefox/releases/128.6.0esr/mac/en-US/Firefox%20128.6.0esr.pkg"

# Define the output path for the downloaded `.pkg` file
PKG_FILE="$HOME/Downloads/Firefox-128.6.0esr.pkg"

# Check if the Firefox ESR `.pkg` is already downloaded
if [ -f "$PKG_FILE" ]; then
    echo "Firefox ESR package already downloaded at $PKG_FILE."
else
    echo "Downloading Firefox ESR package..."
    curl -L -C - "$FIREFOX_PKG_URL" --output "$PKG_FILE"

    if [[ $? -ne 0 ]]; then
        echo "Failed to download Firefox ESR package. Exiting."
        exit 1
    fi
fi

# Install the `.pkg` file
echo "Installing Firefox ESR..."
sudo installer -pkg "$PKG_FILE" -target /

if [[ $? -ne 0 ]]; then
    echo "Failed to install Firefox ESR. Exiting."
    exit 1
fi

echo "Firefox ESR has been installed successfully!"

