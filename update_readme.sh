#!/bin/bash

# Renk kodları
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# README.md'yi oluştur
generate_readme() {
  cat >README.md <<'EOF'
# ~/.dotfiles 🚀

> My Arch Linux Configuration Files

<div align="center">
  <img src="screenshots/review.png" alt="Desktop Preview"/>
</div>

## ⚡️ Stack
EOF

  # Stack bilgilerini ekle
  if [ -d "hypr" ]; then
    echo "- **WM**: Hyprland" >>README.md
  fi
  if [ -d "alacritty" ] || [ -d "kitty" ]; then
    echo "- **Terminal**: Alacritty/Kitty" >>README.md
  fi
  if [ -d "nvim" ]; then
    echo "- **Editor**: Neovim" >>README.md
  fi
  if [ -d "fish" ] || [ -d "zsh" ]; then
    echo "- **Shell**: Fish/Zsh" >>README.md
  fi
  if [ -d "waybar" ]; then
    echo "- **Bar**: Waybar" >>README.md
  fi
  if [ -d "wofi" ]; then
    echo "- **Launcher**: Wofi" >>README.md
  fi
  if [ -d "wleave" ]; then
    echo "- **Session**: Wleave" >>README.md
  fi
  if [ -d "tmux" ]; then
    echo "- **Multiplexer**: Tmux" >>README.md
  fi

  # Mevcut kurulum yapısını ekle
  cat >>README.md <<'EOF'

## 🛠 Current Setup
```bash
~/.dotfiles
EOF

  # Dizinleri listele ve açıklamalarını ekle
  for dir in */; do
    if [[ ! "$dir" =~ ^\. && "$dir" != "screenshots/" ]]; then
      dir_name="${dir%/}"
      case "$dir_name" in
      "alacritty")
        echo "├── $dir_name/       # GPU-accelerated terminal" >>README.md
        ;;
      "bin")
        echo "├── $dir_name/         # Custom scripts" >>README.md
        ;;
      "fish")
        echo "├── $dir_name/         # Fish shell config" >>README.md
        ;;
      "hypr")
        echo "├── $dir_name/         # Hyprland config" >>README.md
        ;;
      "kitty")
        echo "├── $dir_name/        # Modern terminal emulator" >>README.md
        ;;
      "mpv")
        echo "├── $dir_name/          # Media player" >>README.md
        ;;
      "ncmpcpp")
        echo "├── $dir_name/      # Terminal music player" >>README.md
        ;;
      "nvim")
        echo "├── $dir_name/         # Editor of the gods" >>README.md
        ;;
      "ranger")
        echo "├── $dir_name/       # CLI file manager" >>README.md
        ;;
      "sem")
        echo "├── $dir_name/          # System enhancement modules" >>README.md
        ;;
      "sesh")
        echo "├── $dir_name/         # Terminal session manager" >>README.md
        ;;
      "starship")
        echo "├── $dir_name/     # Cross-shell prompt" >>README.md
        ;;
      "systemd")
        echo "├── $dir_name/      # Service configuration" >>README.md
        ;;
      "tmux")
        echo "├── $dir_name/         # Terminal multiplexer" >>README.md
        ;;
      "touchegg")
        echo "├── $dir_name/     # Gesture control" >>README.md
        ;;
      "waybar")
        echo "├── $dir_name/       # Wayland bar" >>README.md
        ;;
      "wleave")
        echo "├── $dir_name/       # Session manager" >>README.md
        ;;
      "wofi")
        echo "├── $dir_name/         # Application launcher" >>README.md
        ;;
      *)
        echo "├── $dir_name/" >>README.md
        ;;
      esac
    fi
  done

  # Kurulum bilgilerini ekle
  cat >>README.md <<'EOF'
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

## 📝 License
MIT License - Use as you wish!

---
<div align="center">
  <i>Crafted for Arch Linux</i>
</div>
EOF

  echo -e "${GREEN}✨ README.md başarıyla güncellendi!${NC}"
}

# Ana fonksiyon
main() {
  echo -e "${BLUE}🔍 README.md güncelleniyor...${NC}"
  generate_readme
}

# Scripti çalıştır
main
