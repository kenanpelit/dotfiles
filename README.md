# ~/.dotfiles 🚀

> My Arch Linux Configuration Files

<div align="center">
  <img src="screenshots/review.png" alt="Desktop Preview"/>
</div>

## ⚡️ Stack
- **WM**: Hyprland
- **Terminal**: Alacritty/Kitty
- **Editor**: Neovim
- **Shell**: Fish/Zsh
- **Bar**: Waybar
- **Launcher**: Wofi
- **Session**: Wleave
- **Multiplexer**: Tmux

## 🛠 Current Setup
```bash
~/.dotfiles
├── alacritty/       # GPU-accelerated terminal
├── bin/             # Custom scripts
├── fish/            # Fish shell config
├── hypr/            # Hyprland config
├── kitty/           # Modern terminal emulator
├── mpv/             # Media player
├── ncmpcpp/         # Terminal music player
├── nvim/            # Editor of the gods
├── ranger/          # CLI file manager
├── sem/             # System enhancement modules
├── sesh/            # Terminal session manager
├── starship/        # Cross-shell prompt
├── starship.toml/   # Starship configuration
├── systemd/         # Service configuration
├── tmux/            # Terminal multiplexer
├── touchegg/        # Gesture control
├── waybar/          # Wayland bar
├── wleave/          # Session manager
├── wofi/            # Application launcher
├── zsh/             # Zsh config
└── zshrc/           # Zsh runtime config
```

## 🚀 Quick Start

### Prerequisites
This configuration is specifically designed for Arch Linux. Make sure you have these packages installed:

```bash
# Install required packages
sudo pacman -S git stow base-devel
```

### Installation
Clone and setup the configuration:

```bash
# Clone the repository
git clone git@github.com:kenanpelit/dotfiles.git ~/.dotfiles

# Navigate to the directory
cd ~/.dotfiles

# Make the install script executable
chmod +x install.sh

# Run the installation script
./install.sh
```

The installation script provides the following options:
- Install all configurations
- Install specific configurations
- Uninstall all configurations
- Uninstall specific configurations
- Reinstall all configurations
- Create backup of existing configurations

## 🔧 Manual Management
For manual control using GNU Stow:

```bash
# Install specific config
stow [package]

# Uninstall specific config
stow -D [package]

# Update everything
git pull
```

## 💫 Add New Configs
Create and structure new configuration packages:

```bash
# Create new config directory
mkdir my_awesome_tool

# Follow the stow structure
my_awesome_tool/
└── .config/
    └── my_awesome_tool/
        └── config

# Deploy with stow
stow my_awesome_tool
```

## 🛠️ Dotfiles Manager
A custom script (`dotfiles-manager.sh`) is included to make dotfiles management even easier:

```bash
Usage: dotfiles-manager.sh <command> [options]

Commands:
  addc <name>      Add config file/directory from .config
  addh <name>      Add dotfile/directory from home
  rm <name>        Remove config
  sync             Synchronize all dotfiles
  ls               List existing dotfiles

Examples:
  ./dotfiles-manager.sh addc hypr          # Add Hyprland config dir
  ./dotfiles-manager.sh addc config.txt    # Add single config file
  ./dotfiles-manager.sh addh .zshrc        # Add .zshrc file
  ./dotfiles-manager.sh addh .config       # Add .config directory
  ./dotfiles-manager.sh rm hypr           # Remove config
```

Features:
- Automatic GNU Stow dependency checking
- Color-coded output for better visibility
- Support for both `.config` and home directory dotfiles
- Easy synchronization of all configurations
- Simple listing of managed dotfiles
- Error handling and helpful messages

## 📝 License
MIT License - Use as you wish!

---
<div align="center">
  <i>Crafted for Arch Linux</i>
</div>
