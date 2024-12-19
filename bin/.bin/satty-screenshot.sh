#!/usr/bin/env bash

# Version: 1.0.0
# Date: 2024-12-12
# Author: Kenan Pelit
# Repository: github.com/kenanpelit/dotfiles
# Description: Advanced screenshot script for Hyprland using Satty
# This script provides various screenshot capabilities including:
# - Area selection with editing
# - Direct clipboard copy
# - File saving
# - Full screen capture
# - Notification support
#
# Dependencies:
# - grim (Screenshot utility for Wayland)
# - slurp (Select a region in Wayland)
# - satty (https://github.com/gabm/Satty - Screenshot annotation tool)
# - wl-clipboard (Clipboard utility for Wayland)
# - libnotify (For notifications)
#
# Installation on Arch Linux:
# yay -S grim slurp satty wl-clipboard libnotify
#
# Installation on other distributions:
# - Install dependencies using your package manager
# - Compile satty from source: https://github.com/gabm/Satty

# Set screenshot directory
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

## Check for required dependencies
#dependencies=(grim slurp satty wl-copy notify-send)
#
#for cmd in "${dependencies[@]}"; do
#   if ! command -v "$cmd" >/dev/null 2>&1; then
#       echo "Error: Required command '$cmd' not found."
#       echo "Please install the missing dependencies."
#       exit 1
#  fi
#done

# Create screenshots directory if it doesn't exist
if [[ ! -d "$SCREENSHOT_DIR" ]]; then
  mkdir -p "$SCREENSHOT_DIR"
fi

# Function to generate filename with timestamp
get_filename() {
  echo "$SCREENSHOT_DIR/screenshot-$(date '+%Y%m%d-%H%M%S').png"
}

# Function to notify user
notify() {
  local title="$1"
  local message="$2"
  notify-send "$title" "$message"
}

# Handle different screenshot modes
case $1 in
"select-edit")
  # Select area and open in Satty editor
  grim -g "$(slurp)" -t ppm - |
    satty --filename - --fullscreen --output-filename "$(get_filename)"
  ;;

"select-copy")
  # Select area and copy to clipboard
  grim -g "$(slurp)" -t ppm - |
    satty --filename - --copy-command wl-copy --early-exit
  notify "Screenshot" "Copied to clipboard"
  ;;

"select-save")
  # Select area and save to file
  filename=$(get_filename)
  grim -g "$(slurp)" "$filename"
  notify "Screenshot saved" "$filename"
  ;;

"full-copy")
  # Capture full screen and copy to clipboard
  grim -t ppm - |
    satty --filename - --copy-command wl-copy --early-exit
  notify "Screenshot" "Full screen copied to clipboard"
  ;;

"full-save")
  # Capture full screen and save to file
  filename=$(get_filename)
  grim "$filename"
  notify "Screenshot saved" "$filename"
  ;;

"full-edit")
  # Capture full screen and open in Satty editor
  grim -t ppm - |
    satty --filename - --fullscreen --output-filename "$(get_filename)"
  ;;

*)
  echo "Usage: $0 [select-edit|select-copy|select-save|full-copy|full-save|full-edit]"
  exit 1
  ;;
esac

exit 0
