#!/bin/bash

clear
echo "=========================================="
echo "      CatBrowser System Uninstaller       "
echo "=========================================="
echo ""

# Ask for administrator privileges
if [ "$EUID" -ne 0 ]; then
  echo "[!] This uninstaller needs administrator privileges to remove catbrowser."
  echo "[*] Please enter your password below:"
  exec sudo "$0" "$@"
  exit
fi

# Paths to remove
TARGET_DIR="/usr/local/bin/deps"
DESKTOP_FILE="/usr/share/applications/catbrowser.desktop"

echo "[-] Removing XFCE Application Shortcut..."
if [ -f "$DESKTOP_FILE" ]; then
    rm "$DESKTOP_FILE"
fi

echo "[-] Removing application folder and assets from $TARGET_DIR..."
if [ -d "$TARGET_DIR" ]; then
    rm -rf "$TARGET_DIR"
fi

echo "[-] Refreshing system application desktop caches..."
xfdesktop --reload 2>/dev/null || true

echo ""
echo "================================================================="
echo " SUCCESS: CatBrowser has been completely removed from your system."
echo "================================================================="
echo ""
