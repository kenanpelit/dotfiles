#!/bin/bash

# Yeni desktop entry'nin oluşturulacağı dizin
DEST_DIR="/usr/share/wayland-sessions"
NEW_ENTRY="${DEST_DIR}/hyprflow.desktop"

# Dinamik olarak home dizinini al
HOME_DIR="$HOME"

# Yeni içerik (dinamik home dizini ile)
NEW_CONTENT="[Desktop Entry]
Name=HyprFlow
Comment=Modern Wayland Compositor
Exec=${HOME_DIR}/.config/hypr/start/hyprland.sh
Type=Application
DesktopNames=Hyprland"

# Dizinin varlığını kontrol et ve dosyayı oluştur
if [ -d "$DEST_DIR" ]; then
  # Yeni dosyayı oluştur
  echo "$NEW_CONTENT" | sudo tee "$NEW_ENTRY" >/dev/null
  # Dosya izinlerini ayarla
  sudo chmod 644 "$NEW_ENTRY"
  echo "Yeni desktop entry başarıyla oluşturuldu: $NEW_ENTRY"
else
  echo "Hata: Hedef dizin bulunamadı: $DEST_DIR"
  exit 1
fi
