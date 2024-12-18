#!/usr/bin/env bash
#######################################
#
# Version: 1.0.0
# Date: 2024-12-12
# Author: Kenan Pelit
# Repository: github.com/kenanpelit/dotfiles
# Description: DotFiles - Kişisel Yapılandırma Dosyaları Yöneticisi
#
# Bu script sistemdeki dotfiles yapılandırmalarını yöneten
# kapsamlı bir araçtır. Temel özellikleri:
#
# - Temel Özellikler:
#   - GNU Stow entegrasyonu
#   - Otomatik yedekleme sistemi
#   - İnteraktif kurulum menüsü
#   - Modüler yapılandırma desteği
#
# - Paket Yönetimi:
#   - Toplu kurulum
#   - Seçmeli kurulum
#   - Kaldırma desteği
#   - Yeniden kurulum özelliği
#
# - Desteklenen Konfigürasyonlar:
#   - Terminal emülatörleri (Alacritty, Kitty)
#   - Kabuk yapılandırmaları (Fish, Zsh)
#   - Pencere yöneticileri (Hypr)
#   - Metin düzenleyiciler (Neovim)
#   - Sistem araçları (Tmux, Waybar, Wofi)
#
# - Güvenlik ve Kontroller:
#   - Yedekleme sistemi
#   - Hata kontrolü
#   - Güvenli kaldırma
#   - Doğrulama kontrolleri
#
# Kullanım:
# ./dotfiles-manager.sh
# Menüden istenen işlem seçilir
#
# License: MIT
#
#######################################
# Renk tanımlamaları
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logo
print_logo() {
  echo -e "${BLUE}"
  echo '    ██╗  ██╗███████╗███╗   ██╗██████╗ '
  echo '    ██║ ██╔╝██╔════╝████╗  ██║██╔══██╗'
  echo '    █████╔╝ █████╗  ██╔██╗ ██║██████╔╝'
  echo '    ██╔═██╗ ██╔══╝  ██║╚██╗██║██╔═══╝ '
  echo '    ██║  ██╗███████╗██║ ╚████║██║     '
  echo '    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═╝     '
  echo -e "${NC}"
  echo -e "${BLUE}Dotfiles Installation Script${NC}"
  echo
}

# Mevcut paketler
packages=(
  "alacritty"
  "bin"
  "fish"
  "fonts"
  "foot"
  "hypr"
  "kitty"
  "mpv"
  "ncmpcpp"
  "nvim"
  "ranger"
  "sem"
  "sesh"
  "starship"
  "systemd"
  "touchegg"
  "uwsm"
  "waybar"
  "wleave"
  "wofi"
  "zsh"
)

# Yardımcı fonksiyonlar
print_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Stow kurulu mu kontrol et
check_stow() {
  if ! command -v stow &>/dev/null; then
    print_error "GNU Stow is not installed!"
    echo "Installing GNU Stow..."
    if command -v pacman &>/dev/null; then
      sudo pacman -S stow
    elif command -v apt &>/dev/null; then
      sudo apt install stow
    else
      print_error "Could not install stow. Please install it manually."
      exit 1
    fi
  fi
}

# Yedek al
backup_existing() {
  local backup_dir="$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"
  print_info "Creating backup at $backup_dir"
  mkdir -p "$backup_dir"

  for package in "${packages[@]}"; do
    if [ -d "$HOME/.config/$package" ]; then
      cp -r "$HOME/.config/$package" "$backup_dir/"
    fi
  done

  print_success "Backup completed"
}

# Paket kur
install_package() {
  local package=$1
  print_info "Installing $package..."
  if stow -v "$package" &>/dev/null; then
    print_success "$package installed"
    return 0
  else
    print_error "Failed to install $package"
    return 1
  fi
}

# Paket kaldır
uninstall_package() {
  local package=$1
  print_info "Uninstalling $package..."
  if stow -D -v "$package" &>/dev/null; then
    print_success "$package uninstalled"
    return 0
  else
    print_error "Failed to uninstall $package"
    return 1
  fi
}

# Ana menü
main_menu() {
  clear
  print_logo
  echo "What would you like to do?"
  echo
  echo "1) Install all packages"
  echo "2) Install specific packages"
  echo "3) Uninstall all packages"
  echo "4) Uninstall specific packages"
  echo "5) Reinstall all packages"
  echo "6) Create backup"
  echo "0) Exit"
  echo
  read -p "Enter your choice: " choice

  case $choice in
  1) install_all ;;
  2) install_specific ;;
  3) uninstall_all ;;
  4) uninstall_specific ;;
  5) reinstall_all ;;
  6) backup_existing ;;
  0) exit 0 ;;
  *) print_error "Invalid choice" && sleep 2 && main_menu ;;
  esac
}

# Tüm paketleri kur
install_all() {
  print_info "Installing all packages..."
  backup_existing
  for package in "${packages[@]}"; do
    install_package "$package"
  done
  print_success "All packages installed"
  read -p "Press Enter to continue..."
  main_menu
}

# Belirli paketleri kur
install_specific() {
  clear
  print_logo
  echo "Available packages:"
  for i in "${!packages[@]}"; do
    echo "$((i + 1))) ${packages[i]}"
  done
  echo
  read -p "Enter package numbers (space-separated): " -a selections

  for sel in "${selections[@]}"; do
    if [ "$sel" -gt 0 ] && [ "$sel" -le "${#packages[@]}" ]; then
      install_package "${packages[$((sel - 1))]}"
    fi
  done

  read -p "Press Enter to continue..."
  main_menu
}

# Tüm paketleri kaldır
uninstall_all() {
  print_warning "This will remove all dotfiles. Are you sure? (y/N)"
  read -r confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    for package in "${packages[@]}"; do
      uninstall_package "$package"
    done
  fi
  read -p "Press Enter to continue..."
  main_menu
}

# Belirli paketleri kaldır
uninstall_specific() {
  clear
  print_logo
  echo "Installed packages:"
  for i in "${!packages[@]}"; do
    echo "$((i + 1))) ${packages[i]}"
  done
  echo
  read -p "Enter package numbers to uninstall (space-separated): " -a selections

  for sel in "${selections[@]}"; do
    if [ "$sel" -gt 0 ] && [ "$sel" -le "${#packages[@]}" ]; then
      uninstall_package "${packages[$((sel - 1))]}"
    fi
  done

  read -p "Press Enter to continue..."
  main_menu
}

# Tüm paketleri yeniden kur
reinstall_all() {
  print_warning "This will reinstall all dotfiles. Continue? (y/N)"
  read -r confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    uninstall_all
    install_all
  fi
  main_menu
}

# Script başlangıcı
check_stow
main_menu
