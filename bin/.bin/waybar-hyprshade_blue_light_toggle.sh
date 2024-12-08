#!/usr/bin/env bash

# Kullanılabilecek shader dosyaları
SHADER_PATH="$HOME/.config/hypr/shaders"
KENP_SHADER="$SHADER_PATH/kenp-blue-light-filter.glsl"
GNOME_SHADER="$SHADER_PATH/gnome-blue-light-filter.glsl"
DEFAULT_SHADER="$SHADER_PATH/blue-light-filter.glsl"
ORTA_SHADER="$SHADER_PATH/orta-blue-light-filter.glsl"

# Parametre kontrolü - Varsayılan olarak "kenp" ayarını seçiyoruz
if [ -z "$1" ]; then
  SHADER_FILE=$KENP_SHADER
  SHADER_NAME="Kenp Blue Light Filter"
elif [ "$1" == "kenp" ]; then
  SHADER_FILE=$KENP_SHADER
  SHADER_NAME="Kenp Blue Light Filter"
elif [ "$1" == "gnome" ]; then
  SHADER_FILE=$GNOME_SHADER
  SHADER_NAME="GNOME Blue Light Filter"
elif [ "$1" == "orta" ]; then
  SHADER_FILE=$ORTA_SHADER
  SHADER_NAME="Orta Blue Light Filter"
elif [ "$1" == "default" ]; then
  SHADER_FILE=$DEFAULT_SHADER
  SHADER_NAME="Default Blue Light Filter"
else
  echo "Kullanım: $0 [kenp|gnome|orta|default]"
  exit 1
fi

# Shader dosyasının var olup olmadığını kontrol et
if [ ! -f "$SHADER_FILE" ]; then
  notify-send -u critical "Hyprshade Hatası" "$SHADER_NAME dosyası bulunamadı!"
  echo "$SHADER_NAME dosyası bulunamadı: $SHADER_FILE"
  exit 1
fi

# Hyprshade'i seçilen shader ile etkinleştir
hyprshade on "$SHADER_FILE"

# Eğer parametre verilmişse bildirim gönder
if [ -n "$1" ]; then
  notify-send -u normal "Hyprshade Uygulandı" "$SHADER_NAME etkinleştirildi."
fi

echo "$SHADER_NAME etkinleştirildi."
