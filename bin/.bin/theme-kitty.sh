#!/bin/bash
#######################################
#
# Version: 1.0.0
# Date: 2024-12-12
# Author: Kenan Pelit
# Repository: github.com/kenanpelit/dotfiles
# Description: KittyThemeManager - Kitty Terminal Renk Teması Yöneticisi
#
# Bu script Kitty terminal için kapsamlı bir renk teması yönetim sistemi sağlar.
# Temel özellikleri:
#
# - 9 Farklı Tema Desteği:
#   - Kenp (Özel tema)
#   - Tokyo
#   - Mocha
#   - Dracula
#
# - Tema Yönetimi:
#   - Tema değiştirme
#   - Temalar arası geçiş
#   - Otomatik yedekleme
#   - Canlı yenileme
#
# - Renk Özellikleri:
#   - Terminal renkleri (16 renk)
#   - İmleç renkleri
#   - Seçim renkleri
#   - Tab çubuğu renkleri
#   - URL ve işaretleme renkleri
#   - Pencere kenar renkleri
#
# - Sistem Entegrasyonu:
#   - Bildirim sistemi
#   - Kitty soket desteği
#   - Yapılandırma yedekleme
#
# Dizin: ~/.config/kitty/
# Dosya: theme.conf
#
# License: MIT
#
#######################################
KITTY_DIR="/home/kenan/.config/kitty"
THEME_FILE="$KITTY_DIR/theme.conf"
THEME_MARKER="# Current theme: "

# 1. En İyi Önerim
#foreground = "#c0caf5"
# Tokyo Night foreground
# Neden: Daha canlı, mavi alt tonu daha belirgin, okuma konforu yüksek
# HSL: 228°, 63%, 85%

# 2. Daha Nötr Seçenek
#foreground = "#c5ccdc"
# Özel karışım
# Neden: Daha dengeli gri-mavi, yormuyor
# HSL: 220°, 26%, 82%

# 3. Hafif Sıcak Ton
#foreground = "#cdd6f4"
# Catppuccin Mocha foreground
# Neden: Çok hafif mor alt ton, sıcak ve rahat
# HSL: 227°, 70%, 88%

# 4. Yüksek Kontrast
#foreground = "#d3d7e5"
# Özel karışım
# Neden: Daha yüksek kontrast isteyenler için
# HSL: 225°, 25%, 86%

# 5. Soft Ton
#foreground = "#b8c0d4"
# Özel karışım
# Neden: Daha yumuşak, göz yormayan
# HSL: 222°, 23%, 78%
# Kenp Theme (Custom)

read -r -d '' KENP <<'EOF'
# Kenp Theme
## Basic Colors
background              #24283B
foreground              #d8dae9
selection_foreground    #282a36
selection_background    #bd93f9
## Cursor Colors
cursor                  #bd93f9
cursor_text_color       #282a36
## URL Color
url_color              #8be9fd
## Window Border Colors
active_border_color     #bd93f9
inactive_border_color   #44475a
bell_border_color      #f1fa8c
## Tab Bar Colors
active_tab_foreground   #282a36
active_tab_background   #bd93f9
inactive_tab_foreground #f8f8f2
inactive_tab_background #282a36
tab_bar_background      #1e1f29
## Mark Colors
mark1_foreground #282a36
mark1_background #bd93f9
mark2_foreground #282a36
mark2_background #ff79c6
mark3_foreground #282a36
mark3_background #8be9fd
## Terminal Colors
# Black
color0  #595D71
color8  #6272a4
# Red
color1  #f38ba8
color9  #e95678
# Green
color2  #50fa7b
color10 #69ff94
# Yellow
color3  #f1fa8c
color11 #ffffa5
# Blue
color4  #bd93f9
color12 #d6acff
# Magenta
color5  #ff79c6
color13 #ff92df
# Cyan
color6  #8be9fd
color14 #a4ffff
# White
color7  #f8f8f2
color15 #ffffff
EOF

# Tokyo Theme
read -r -d '' TOKYO <<'EOF'
# Tokyo Night Theme
## Basic Colors
background              #1a1b26
#foreground              #c0caf5
foreground              #c0caf5
selection_foreground    #c0caf5
selection_background    #283457
## Cursor Colors
cursor                  #c0caf5
cursor_text_color       #1a1b26
## URL Color
url_color              #73daca
## Window Border Colors
active_border_color     #7aa2f7
inactive_border_color   #292e42
bell_border_color      #e0af68
## Tab Bar Colors
active_tab_foreground   #1a1b26
active_tab_background   #7aa2f7
inactive_tab_foreground #545c7e
inactive_tab_background #1a1b26
tab_bar_background      #15161e
## Mark Colors
mark1_foreground #1a1b26
mark1_background #7aa2f7
mark2_foreground #1a1b26
mark2_background #9ece6a
mark3_foreground #1a1b26
mark3_background #e0af68
## Terminal Colors
# Black
color0  #15161e
color8  #414868
# Red
color1  #f7768e
color9  #f7768e
# Green
color2  #9ece6a
color10 #9ece6a
# Yellow
color3  #e0af68
color11 #e0af68
# Blue
color4  #7aa2f7
color12 #7aa2f7
# Magenta
color5  #bb9af7
color13 #bb9af7
# Cyan
color6  #7dcfff
color14 #7dcfff
# White
color7  #a9b1d6
color15 #c0caf5
EOF

# Catppuccin Mocha Theme
read -r -d '' MOCHA <<'EOF'
# Catppuccin Mocha Theme
## Basic Colors
background              #1e1e2e
#foreground              #cdd6f4
foreground              #c0caf5
selection_foreground    #1e1e2e
selection_background    #f5e0dc
## Cursor Colors
cursor                  #f5e0dc
cursor_text_color       #1e1e2e
## URL Color
url_color              #f5e0dc
## Window Border Colors
active_border_color     #b4befe
inactive_border_color   #6c7086
bell_border_color      #f9e2af
## Tab Bar Colors
active_tab_foreground   #1e1e2e
active_tab_background   #cba6f7
inactive_tab_foreground #cdd6f4
inactive_tab_background #181825
tab_bar_background      #11111b
## Mark Colors
mark1_foreground #1e1e2e
mark1_background #b4befe
mark2_foreground #1e1e2e
mark2_background #cba6f7
mark3_foreground #1e1e2e
mark3_background #74c7ec
## Terminal Colors
# Black
color0  #45475a
color8  #585b70
# Red
color1  #f38ba8
color9  #f38ba8
# Green
color2  #a6e3a1
color10 #a6e3a1
# Yellow
color3  #f9e2af
color11 #f9e2af
# Blue
color4  #89b4fa
color12 #89b4fa
# Magenta
color5  #f5c2e7
color13 #f5c2e7
# Cyan
color6  #94e2d5
color14 #94e2d5
# White
color7  #bac2de
color15 #a6adc8
EOF

# Dracula Theme
read -r -d '' DRACULA <<'EOF'
# Dracula Theme Enhanced
## Basic Colors
background              #21222C
foreground              #d8dae9
selection_foreground    #282a36
selection_background    #44475a
## Cursor Colors
cursor                  #bd93f9
cursor_text_color      #282a36
## URL Color
url_color              #ff79c6
url_style              underline
## Window Border Colors
active_border_color     #bd93f9
inactive_border_color   #44475a
bell_border_color      #f1fa8c
## Tab Bar Colors
tab_bar_style          fade
active_tab_foreground   #282a36
active_tab_background   #bd93f9
inactive_tab_foreground #f8f8f2
inactive_tab_background #282a36
tab_bar_background      #1e1f29
## Mark Colors
mark1_foreground #282a36
mark1_background #bd93f9
mark2_foreground #282a36
mark2_background #ff79c6
mark3_foreground #282a36
mark3_background #8be9fd
## Terminal Colors
# Black
color0  #44475a
color8  #565b70
# Red (Pastel)
color1  #ffb3c1
color9  #ffc1d0
# Green
color2  #50fa7b
color10 #69ff94
# Yellow
color3  #f1fa8c
color11 #ffffa5
# Blue
color4  #bd93f9
color12 #d6acff
# Magenta
color5  #ff79c6
color13 #ff92df
# Cyan
color6  #8be9fd
color14 #a4ffff
# White
color7  #f8f8f2
color15 #ffffff
## Extra Features
cursor_blink_interval   0.5
cursor_stop_blinking_after 5.0
#background_opacity      0.95
EOF

# Available themes array
declare -A THEMES=(
  ["kenp"]="$KENP"
  ["tokyo"]="$TOKYO"
  ["catppuccin_mocha"]="$MOCHA"
  ["dracula"]="$DRACULA"
)

# Function to list available themes
list_themes() {
  echo -e "\033[1;34mAvailable themes:\033[0m"
  current=$(get_current_theme)
  for theme in "${!THEMES[@]}"; do
    if [ "$theme" = "$current" ]; then
      echo -e "  \033[1;32m* $theme \033[1;33m(current)\033[0m"
    else
      echo "    $theme"
    fi
  done
}

# Function to show notifications
notify() {
  local theme=$1
  local message="Kitty theme switched to ${theme}"
  local formatted_theme=$(echo "$theme" | tr '_' ' ' | sed 's/.*/\u&/')

  echo -e "\033[1;32m$message\033[0m"
  notify-send "Kitty Theme" "$formatted_theme" --icon=terminal
}

# Get current theme from file
get_current_theme() {
  grep "^$THEME_MARKER" "$THEME_FILE" | cut -d' ' -f4 || echo "kenp"
}

# Apply theme to kitty config
apply_theme() {
  local theme_name=$1
  local theme_content="${THEMES[$theme_name]}"

  # Create backup
  cp "$THEME_FILE" "${THEME_FILE}.bak"

  # Write the theme marker and content
  echo "$THEME_MARKER$theme_name" >"$THEME_FILE"
  echo "$theme_content" >>"$THEME_FILE"

  # Show notifications
  notify "$theme_name"

  # Reload kitty configuration if running
  if [ -n "$KITTY_SOCKET" ]; then
    kitty @ set-colors --all "$THEME_FILE"
  fi
}

# Toggle between themes
toggle_theme() {
  current_theme=$(get_current_theme)
  local next_theme=""
  local found=0

  for theme in "${!THEMES[@]}"; do
    if [ $found -eq 1 ]; then
      next_theme=$theme
      break
    fi
    if [ "$theme" = "$current_theme" ]; then
      found=1
    fi
  done

  # If we're at the last theme or theme not found, go back to first
  if [ -z "$next_theme" ]; then
    next_theme=$(echo "${!THEMES[@]}" | cut -d' ' -f1)
  fi

  apply_theme "$next_theme"
}

# Show help
show_help() {
  echo "Usage: $0 [OPTION] [THEME]"
  echo
  echo "Options:"
  echo "  -l, --list     List available themes"
  echo "  -t, --toggle   Toggle to next theme"
  echo "  -h, --help     Show this help message"
  echo "  -c, --current  Show current theme"
  echo
  echo "Available themes:"
  for theme in "${!THEMES[@]}"; do
    echo "  - $theme"
  done
  echo
  echo "Examples:"
  echo "  $0 -t                  # Toggle to next theme"
  echo "  $0 nord               # Switch to Nord theme"
  echo "  $0 -l                  # List all themes"
}

# Main script logic
case "$1" in
"" | "-t" | "--toggle")
  toggle_theme
  ;;
"-l" | "--list")
  list_themes
  ;;
"-h" | "--help")
  show_help
  ;;
"-c" | "--current")
  current_theme=$(get_current_theme)
  echo -e "Current theme: \033[1;32m$current_theme\033[0m"
  ;;
*)
  if [ -n "${THEMES[$1]}" ]; then
    apply_theme "$1"
  else
    echo -e "\033[1;31mError: Theme '$1' not found\033[0m"
    echo "Available themes:"
    list_themes
    exit 1
  fi
  ;;
esac
