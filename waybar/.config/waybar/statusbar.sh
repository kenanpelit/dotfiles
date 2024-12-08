#!/usr/bin/env bash
# Combined script to update Waybar temperature sensor path and launch Waybar

# Paths for configuration and style files
CONFIG="$HOME/.config/waybar/config.jsonc"
STYLE="$HOME/.config/waybar/style.css"

# Debug information for original style path
echo "Original style path: $STYLE"

# Resolve the actual path of the style file if it's a symbolic link
if [ -L "$STYLE" ]; then
  REAL_STYLE=$(readlink "$STYLE")
  echo "Direct symlink points to: $REAL_STYLE"

  # If the path is relative, make it absolute
  if [[ "$REAL_STYLE" != /* ]]; then
    STYLE="$(dirname "$STYLE")/$REAL_STYLE"
  else
    STYLE="$REAL_STYLE"
  fi
  echo "Final resolved style path: $STYLE"
fi

# Determine temperature sensor path by searching through hwmon devices
for i in /sys/class/hwmon/hwmon*/temp*_input; do
  # Check if current sensor is Core 0
  if [ "$(<$(dirname "$i")/name): $(cat "${i%_*}_label" 2>/dev/null || echo "$(basename "${i%_*}")")" = "coretemp: Core 0" ]; then
    export HWMON_PATH="$i"
    break # Exit loop when Core 0 sensor is found
  fi
done

# Update the hwmon-path in config.jsonc with the found HWMON_PATH
if [ -n "$HWMON_PATH" ]; then
  sed -i "/hwmon-path/c\ \ \ \ \"hwmon-path\": \"$HWMON_PATH\"," "$CONFIG"
else
  echo "HWMON_PATH not found, config.jsonc could not be updated."
fi

# Wait briefly for the update to complete
sleep 1

# Check if Waybar is already running and launch if not
if ! pgrep -x "waybar" >/dev/null; then
  # Check if style file exists
  if [ ! -f "$STYLE" ]; then
    echo "Style file not found at: $STYLE"
    # Print additional debug information
    ls -l "$STYLE"
    echo "Directory contents of $(dirname "$STYLE"):"
    ls -la "$(dirname "$STYLE")"
    exit 1
  fi

  # Launch Waybar with specified configuration and style files
  waybar --log-level error --config "$CONFIG" --style "$STYLE"
else
  echo "Waybar is already running."
fi
