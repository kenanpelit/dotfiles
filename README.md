# ~/.dotfiles 🚀
> My cozy corner in the command line universe

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
.
├── alacritty/   # GPU-accelerated terminal
├── bin/   # Custom scripts
├── fish/   # Fish shell config
├── hypr/   # Hyprland config
├── kitty/   # Modern terminal emulator
├── mpv/   # Media player
├── ncmpcpp/
├── nvim/   # Editor of the gods
├── ranger/   # CLI file manager
├── sem/
├── sesh/   # Terminal session manager
├── starship/   # Cross-shell prompt
├── starship.toml/
├── systemd/
├── tmux/   # Terminal multiplexer
├── touchegg/
├── waybar/   # Wayland bar
├── wleave/
├── wofi/   # Application launcher
├── zsh/
├── zshrc/
```

## 🚀 Quick Start
### Prerequisites
This dotfiles configuration is optimized for Arch Linux.
```bash
# Required packages for Arch Linux
sudo pacman -S git stow
```

### Installation
We provide an interactive installation script that makes managing your dotfiles a breeze:
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

The script provides the following options:
- Install all configurations
- Install specific configurations
- Uninstall all configurations
- Uninstall specific configurations
- Reinstall all configurations
- Create backup of existing configurations

## 🔧 Manual Management
If you prefer manual control, you can still use stow directly:
```bash
# Install specific config
stow [package]

# Uninstall specific config
stow -D [package]

# Update everything
git pull
```

## 💫 Add New Configs
```bash
# Create new config dir
mkdir my_awesome_tool

# Structure it right
my_awesome_tool/
└── .config/
    └── my_awesome_tool/
        └── config

# Deploy
stow my_awesome_tool
```

## 📝 License
MIT, do whatever you want with it! 🤘

---
<div align="center">
  <i>powered by caffeine and late night coding sessions</i>
</div>
