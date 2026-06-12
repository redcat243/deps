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
curl -fsSL https://raw.githubusercontent/redcat243/deps/main/catbrowser -o catbrowser
curl -fsSL https://raw.githubusercontent/redcat243/deps/main/webview.h -o webview.h
curl -fsSL https://raw.githubusercontent/redcat243/deps/main/sammy.png -o sammy.png
curl -fsSL https://raw.githubusercontent/redcat243/deps/main/cathome.html -o cathome.html
curl -fsSL https://raw.githubusercontent/redcat243/deps/main/about.html -o about.html

# 2. Copy the binary and necessary resources to the deployment path
echo "[+] Deploying application assets..."
cp ~/catbrowser /usr/local/bin/deps
cp ~/about.html /usr/local/bin/deps
cp ~/sammy.png /usr/local/bin/deps
cp ~/webview.h /usr/local/bin/deps
cp ~/cathome.html /usr/local/bin/deps
rm -rf cathome.html
rm -rf sammy.png
rm -rf webview.h
rm -rf about.html
rm -rf catbrowser

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
