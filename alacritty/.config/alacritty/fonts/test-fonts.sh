#!/bin/bash

ALACRITTY_DIR="$HOME/.config/alacritty"
FONTS_DIR="$ALACRITTY_DIR/fonts"
FONTS_CONF="$ALACRITTY_DIR/fonts.toml"
BACKUP_CONF="$ALACRITTY_DIR/fonts.toml.bak"

# Mevcut konfigürasyonu yedekle
if [ -f "$FONTS_CONF" ]; then
  cp "$FONTS_CONF" "$BACKUP_CONF"
fi

test_font() {
  local font_conf="$1"
  local font_name=$(basename "$font_conf" .toml)
  echo "Testing Alacritty font configuration: $font_name"
  cp "$font_conf" "$FONTS_CONF"

  # Font açıklamasını al (ilk satırdaki yorum)
  local description=$(head -n1 "$font_conf" | sed 's/# //')

  alacritty -e bash -c "echo -e '\033[1mTest font: $font_name\033[0m
\033[3m$description\033[0m

The quick brown fox jumps over the lazy dog
ABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz
1234567890 !@#$%^&*()
-> => != >= <= ==
▶ ► • ✔ ✓ ■ □ ▪ ▫ ❯ ❮ ➜ ═ ─ │

Press Enter to continue...'; read"
}

for conf in "$FONTS_DIR"/*.toml; do
  if [ -f "$conf" ]; then
    test_font "$conf"
  fi
done

# Orijinal konfigürasyonu geri yükle
if [ -f "$BACKUP_CONF" ]; then
  cp "$BACKUP_CONF" "$FONTS_CONF"
fi

echo "Alacritty font testi tamamlandı!"
echo "Bir fontu kalıcı olarak kullanmak için: cp fonts/FONT_ADI.toml fonts.toml"
