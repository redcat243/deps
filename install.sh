#!/bin/bash

# Clear terminal screen for clean presentation
clear
echo "=========================================="
echo "      CatBrowser System Installer         "
echo "=========================================="
echo ""

# 1. Ask for admin privileges cleanly right at the start
if [ "$EUID" -ne 0 ]; then
  echo "[!] This installer needs administrator privileges to set up folders."
  echo "[*] Please enter your password below:"
  exec sudo "$0" "$@"
  exit
fi

TARGET_DIR="/usr/local/bin/deps"
DESKTOP_FILE="/usr/share/applications/catbrowser.desktop"

echo "[+] Creating deployment folder at $TARGET_DIR..."
mkdir -p "$TARGET_DIR"

# Dynamically find the real user's home directory instead of /root/
USER_HOME=$(eval echo "~$SUDO_USER")

echo "[+] Downloading assets to home directory..."
curl -fsSL https://raw.githubusercontent.com/redcat243/deps/main/catbrowser -o "$USER_HOME/catbrowser"
curl -fsSL https://raw.githubusercontent.com/redcat243/deps/main/webview.h -o "$USER_HOME/webview.h"
curl -fsSL https://raw.githubusercontent.com/redcat243/deps/main/sammy.png -o "$USER_HOME/sammy.png"
curl -fsSL https://raw.githubusercontent.com/redcat243/deps/main/cathome.html -o "$USER_HOME/cathome.html"
curl -fsSL https://raw.githubusercontent.com/redcat243/deps/main/about.html -o "$USER_HOME/about.html"

# 2. Copy the binary and necessary resources to the deployment path
echo "[+] Deploying application assets..."
cp "$USER_HOME/catbrowser" "$TARGET_DIR/"
cp "$USER_HOME/about.html" "$TARGET_DIR/"
cp "$USER_HOME/sammy.png" "$TARGET_DIR/"
cp "$USER_HOME/webview.h" "$TARGET_DIR/"
cp "$USER_HOME/cathome.html" "$TARGET_DIR/"

# Ensure the deployed binary has execution rights
chmod +x "$TARGET_DIR/catbrowser"

# Clean up the downloaded files from the home directory
echo "[+] Cleaning up temporary files..."
rm -f "$USER_HOME/cathome.html"
rm -f "$USER_HOME/sammy.png"
rm -f "$USER_HOME/webview.h"
rm -f "$USER_HOME/about.html"
rm -f "$USER_HOME/catbrowser"

# 3. Create the system desktop menu shortcut inside the Internet group
echo "[+] Generating XFCE Application Shortcut..."
cat << 'DESKTOP' > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=CatBrowser
Comment=CatBrowser - better for your computer
Exec=/usr/local/bin/deps/catbrowser
Icon=/usr/local/bin/deps/sammy.png
Terminal=false
Categories=Network;WebBrowser;
DESKTOP

chmod +x "$DESKTOP_FILE"

# 4. Display the completion notification message
echo ""
echo "================================================================="
echo " SUCCESS: catbrowser downloading is complete!                   "
echo " Look in your xfce apps > internet to launch it.                 "
echo "================================================================="
echo ""
echo "to uninstall catbrowser run: curl -fsSL https://raw.githubusercontent.com/redcat243/deps/main/uninstall.sh | bash"
