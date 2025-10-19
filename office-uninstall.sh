#!/bin/bash

echo "Welcome to the uninstaller for Troplo's Microsoft Office WINE script."
echo "This will remove all WINE prefixes, the custom WINE build, and desktop entries."
echo ""
echo "This script WILL permanently delete the following:"
echo " - /home/$USER/.wine-msoffice (The entire directory)"
echo " - All *proplus.desktop and *ltsc.desktop files from ~/.local/share/applications/"
echo " - Any leftover downloaded archives (wine-9.7.zst, msoffice.7z, etc.) in /home/$USER/"
echo ""

# Confirmation prompt
read -p "Are you sure you want to proceed? (y/n): " choice
case "$choice" in
  y|Y|yes )
    echo "Starting uninstallation..."
    ;;
  n|N|no )
    echo "Uninstallation cancelled."
    exit 0
    ;;
  * )
    echo "Invalid choice. Aborting."
    exit 1
    ;;
esac

# 1. Stop any running WINE server associated with this install
echo "Attempting to stop the custom WINE server..."
if [ -f "/home/$USER/.wine-msoffice/wine/usr/bin/wineserver" ]; then
    /home/$USER/.wine-msoffice/wine/usr/bin/wineserver -k
    sleep 1 # Give it a second to shut down
else
    echo "Custom WINE server not found, it may already be gone."
fi

# 2. Remove the main installation directory
echo "Removing main directory: /home/$USER/.wine-msoffice"
rm -rf "/home/$USER/.wine-msoffice"

# 3. Remove the desktop entries
echo "Removing desktop application entries..."
rm -f ~/.local/share/applications/word-proplus.desktop
rm -f ~/.local/share/applications/access-proplus.desktop
rm -f ~/.local/share/applications/excel-proplus.desktop
rm -f ~/.local/share/applications/powerpoint-proplus.desktop
rm -f ~/.local/share/applications/publisher-proplus.desktop
rm -f ~/.local/share/applications/outlook-proplus.desktop
rm -f ~/.local/share/applications/word-ltsc.desktop
rm -f ~/.local/share/applications/access-ltsc.desktop
rm -f ~/.local/share/applications/excel-ltsc.desktop
rm -f ~/.local/share/applications/powerpoint-ltsc.desktop
rm -f ~/.local/share/applications/publisher-ltsc.desktop
rm -f ~/.local/share/applications/outlook-ltsc.desktop

# 4. Update the desktop menu
echo "Updating application menu..."
xdg-desktop-menu forceupdate

# 5. Remove leftover downloaded archives
echo "Cleaning up downloaded archives from /home/$USER/..."
rm -f "/home/$USER/wine-9.7.zst"
rm -f "/home/$USER/msoffice.7z"
rm -f "/home/$USER/msoffice_ltsc.7z"
rm -f "/home/$USER/msoffice_script_icons.7z"

echo ""
echo "Uninstallation complete. ✅"
echo ""
echo "NOTE: This script did NOT remove the dependencies (like wine, freetype2, etc.)"
echo "installed by 'yay' or 'paru'. It is generally unsafe to remove these"
echo "as other applications may depend on them."
