#!/bin/bash

#===============================================================================
#   Script: Dotfiles Manager with GNU Stow
#   Author: Kenan Pelit
#   Version: 1.0.1
#   Created: December 04, 2023
#   Description: A simple dotfiles management script using GNU Stow
#   Github: github.com/kenanpelit
#   License: MIT
#===============================================================================

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOTFILES_DIR="$HOME/.dotfiles"

check_stow() {
  if ! command -v stow &>/dev/null; then
    echo -e "${RED}GNU Stow not found!${NC}"
    echo -e "${YELLOW}For installation:${NC}"
    echo "Arch Linux: sudo pacman -S stow"
    echo "Ubuntu/Debian: sudo apt install stow"
    echo "Fedora: sudo dnf install stow"
    exit 1
  fi
}

usage() {
  echo "Dotfiles Management with GNU Stow"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo
  echo "Usage: $(basename $0) <command> [options]"
  echo
  echo "Commands:"
  echo "  addc <name>      Add config file/directory from .config"
  echo "  addh <name>      Add dotfile/directory from home"
  echo "  rm <name>        Remove config"
  echo "  sync             Synchronize all dotfiles"
  echo "  ls               List existing dotfiles"
  echo
  echo "Examples:"
  echo "  $(basename $0) addc hypr          Add Hyprland config dir"
  echo "  $(basename $0) addc config.txt    Add single config file"
  echo "  $(basename $0) addh .zshrc        Add .zshrc file"
  echo "  $(basename $0) addh .config       Add .config directory"
  echo "  $(basename $0) rm hypr           Remove config"
}

add_config() {
  check_stow
  local source=$1
  local config_path="$HOME/.config/$source"

  if [[ -e "$config_path" ]]; then
    mkdir -p "$DOTFILES_DIR/$source/.config"
    mv "$config_path" "$DOTFILES_DIR/$source/.config/"
    cd "$DOTFILES_DIR" && stow "$source"
    echo -e "${GREEN}Successfully added $source${NC}"
    return 0
  fi
  echo -e "${RED}Error: $config_path not found${NC}"
  return 1
}

add_home_dotfile() {
  check_stow
  local source=$1
  local source_path="$HOME/$source"
  local program_name=${source#.}

  if [[ -e "$source_path" ]]; then
    mkdir -p "$DOTFILES_DIR/$program_name"
    mv "$source_path" "$DOTFILES_DIR/$program_name/"
    cd "$DOTFILES_DIR" && stow "$program_name"
    echo -e "${GREEN}Successfully added $source${NC}"
    return 0
  fi
  echo -e "${RED}Error: $source_path not found${NC}"
  return 1
}

remove_config() {
  check_stow
  local program=$1

  if [[ ! -d "$DOTFILES_DIR/$program" ]]; then
    echo -e "${RED}Error: $program not found in dotfiles${NC}"
    return 1
  fi

  cd "$DOTFILES_DIR" && stow -D "$program"

  if [[ -d "$DOTFILES_DIR/$program/.config" ]]; then
    mv "$DOTFILES_DIR/$program/.config/$program" "$HOME/.config/"
  else
    mv "$DOTFILES_DIR/$program/.$program" "$HOME/"
  fi

  rm -rf "$DOTFILES_DIR/$program"
  echo -e "${GREEN}Successfully removed $program${NC}"
}

sync_dotfiles() {
  check_stow
  echo -e "${BLUE}Synchronizing dotfiles...${NC}"
  cd "$DOTFILES_DIR"

  for dir in */; do
    program=${dir%/}
    stow -R "$program"
    echo -e "${GREEN}Synchronized $program${NC}"
  done
}

list_dotfiles() {
  [[ ! -d "$DOTFILES_DIR" || -z "$(ls -A "$DOTFILES_DIR")" ]] && {
    echo -e "${YELLOW}No dotfiles added yet.${NC}"
    return
  }

  echo -e "${BLUE}Current dotfiles:${NC}"
  cd "$DOTFILES_DIR"

  echo -e "${YELLOW}Files in .config:${NC}"
  found_configs=false
  for dir in */; do
    [[ -d "$DOTFILES_DIR/${dir%/}/.config" ]] && {
      echo "  - ${dir%/} (.config)"
      found_configs=true
    }
  done

  [[ "$found_configs" = false ]] && echo "  No .config files added yet"

  echo -e "\n${YELLOW}Files in home:${NC}"
  found_home_files=false
  for dir in */; do
    [[ ! -d "$DOTFILES_DIR/${dir%/}/.config" ]] && {
      echo "  - .${dir%/}"
      found_home_files=true
    }
  done

  [[ "$found_home_files" = false ]] && echo "  No home dotfiles added yet"
}

main() {
  [[ ! -d "$DOTFILES_DIR" ]] && mkdir -p "$DOTFILES_DIR"

  case "$1" in
  "addc")
    [[ -z "$2" ]] && {
      echo -e "${RED}Error: Name required${NC}"
      usage
      exit 1
    }
    add_config "$2"
    ;;
  "addh")
    [[ -z "$2" ]] && {
      echo -e "${RED}Error: Name required${NC}"
      usage
      exit 1
    }
    add_home_dotfile "$2"
    ;;
  "rm")
    [[ -z "$2" ]] && {
      echo -e "${RED}Error: Name required${NC}"
      usage
      exit 1
    }
    remove_config "$2"
    ;;
  "sync")
    sync_dotfiles
    ;;
  "ls")
    list_dotfiles
    ;;
  *)
    usage
    exit 1
    ;;
  esac
}

main "$@"
