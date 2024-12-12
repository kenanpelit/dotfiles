# Hyprland Configuration Cheat Sheet

## Overview
This directory contains a modular configuration setup for Hyprland, a modern Wayland compositor. It's designed to keep things clean, organized, and extensible.

## Directory Structure
```
~/.config/hypr
├── config
│   ├── 00_env.conf       # System environment variables
│   ├── 01_shift.conf     # Shift key and keyboard shortcuts
│   ├── 02_monitor.conf   # Monitor and display configurations
│   ├── 03_defaults.conf  # Default system behaviors
│   ├── 04_themes.conf    # Themes and visual customizations
│   ├── 05_winrules.conf  # Window rules and behaviors
│   ├── 06_keybinds.conf  # Keybindings
│   ├── 07_plugins.conf   # System plugins and features
│   ├── 08_autostart.conf # Autostart applications
│   └── themes
│       ├── dracula.conf
│       ├── frappe.conf
│       ├── kenp.conf
│       ├── latte.conf
│       ├── macchiato.conf
│       └── mocha.conf
├── hypridle.conf
├── hyprland.conf          # Main configuration file
├── hyprlock
│   ├── 1.png
│   ├── arch.png
│   ├── avatar.png
│   └── Fonts
│       ├── JetBrains
│       │   └── JetBrains Mono Nerd.ttf
│       └── SF Pro Display
│           ├── SF Pro Display Bold.otf
│           └── SF Pro Display Regular.otf
├── hyprlock.conf          # Hyprlock configuration
├── pyprland.toml          # Pyprland configuration
├── shaders
│   └── kenp-blue-light-filter.glsl
├── start
│   ├── create_hyprflow_login_entry.sh
│   ├── hyprland.sh
│   ├── README.md
│   └── README_TR.md
└── themes
    ├── frappe.conf
    ├── latte.conf
    ├── macchiato.conf
    └── mocha.conf
```

## Key Components
- **`config` Directory:** Modular configuration files sourced in `hyprland.conf` for better organization.
  - `themes/`: Contains theme-specific configurations.
- **`hyprland.conf`:** Main entry point for loading the modular configs.
- **`hyprlock`:** Contains lock screen assets and font files.
- **`shaders`:** Custom GLSL shaders for effects like blue light filtering.
- **`start`:** Scripts for launching Hyprland and managing desktop entries.

## Usage
- **Apply a Theme:** Modify `04_themes.conf` to source the desired theme configuration file from `themes/`.
- **Add Plugins:** Edit `07_plugins.conf` to include new plugins.
- **Autostart Applications:** Add commands in `08_autostart.conf` to run at startup.

## Notes
- Keep configurations modular to simplify updates and debugging.
- Use `hyprland.sh` for launching Hyprland with custom settings or environment variables.
- Lock screen visuals are customizable via `hyprlock` assets and fonts.

Stay nerdy. Keep it clean. Hypr on!

