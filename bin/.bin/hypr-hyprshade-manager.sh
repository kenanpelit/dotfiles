#!/usr/bin/env bash

#######################################
#
# Version: 1.0.0
# Date: 2024-12-08
# Author: Kenan Pelit
# Repository: github.com/kenanpelit/dotfiles
# Description: HyprFlow
#
# License: MIT
#
#######################################

# =================================================================
# Kenp Hyprshade Manager
# -----------------------------------------------------------------
# Bu script, Hyprland masaüstü ortamı için hyprshade yönetimini
# sağlar. İki modda çalışır:
#   1. Servis modu: Arkaplanda çalışarak hyprshade'i yönetir
#   2. Toggle modu: Hyprshade'i açıp kapatır
#
# Kullanım:
#   ./hyprshade-manager.sh [seçenek]
#
# Seçenekler:
#   toggle    : Hyprshade'i açar/kapatır
#   help      : Bu yardım mesajını gösterir
#   status    : Hyprshade durumunu gösterir
#
# Örnekler:
#   ./hyprshade-manager.sh         # Servis olarak çalıştır
#   ./hyprshade-manager.sh toggle  # Aç/Kapat
#   ./hyprshade-manager.sh status  # Durum bilgisi
#   ./hyprshade-manager.sh help    # Yardım
#
# Gereksinimler:
#   - hyprshade
#   - libnotify (notify-send için)
#   - Hyprland
#   - inotify-tools (inotifywait için)
# =================================================================

# Sabit değişkenler
declare -r LOG_FILE="/tmp/hyprshade.log"
declare -r SHADER_PATH="$HOME/.config/hypr/shaders"
declare -r SHADER_FILE="$SHADER_PATH/kenp-blue-light-filter.glsl"
declare -r CONFIG_DIR="$HOME/.config/hypr/config"
declare -r TOGGLE_FILE="/tmp/.hyprshade_active"
declare -i LAST_RESTART=0
declare -i MIN_WAIT=3

# Sinyal yakalayıcı
cleanup() {
  echo "[$(date)] Servis kapatılıyor..."
  hyprshade off
  rm -f "$TOGGLE_FILE"
  exit 0
}

trap cleanup SIGTERM SIGINT

# Yardım mesajını göster
show_help() {
  cat <<EOF
Kenp Hyprshade Manager

KULLANIM:
   $(basename "$0") [SEÇENEK]

SEÇENEKLER:
   toggle    Hyprshade'i açar/kapatır
   status    Hyprshade durumunu gösterir 
   help      Bu yardım mesajını gösterir

ÖRNEKLER:
   $(basename "$0")          # Servis olarak çalıştır
   $(basename "$0") toggle   # Aç/Kapat
   $(basename "$0") status   # Durum kontrolü

Detaylı bilgi için: https://github.com/username/repo
EOF
}

# Config değişikliklerini izleme (inotifywait ile)
monitor_config_changes() {
  echo "[$(date)] Config değişiklikleri izleniyor..."
  inotifywait -m -e modify,create,delete "$CONFIG_DIR" -r 2>/dev/null |
    while read -r directory events filename; do
      if [[ "$filename" =~ \.conf$ ]]; then
        echo "[$(date)] Config değişikliği tespit edildi: $filename"
        sleep 1 # Config'in tamamen kaydedilmesini bekle
        manage_hyprshade false
      fi
    done
}

# Fonksiyon: Hyprshade durumunu kontrol et
check_hyprshade_status() {
  [ -f "$TOGGLE_FILE" ]
  return $?
}

# Durum kontrolü
show_status() {
  if check_hyprshade_status; then
    echo "Hyprshade: AKTİF"
    echo "Shader: $SHADER_FILE"
    echo "Son başlatma: $(stat -c %y "$TOGGLE_FILE")"
  else
    echo "Hyprshade: KAPALI"
  fi
}

# Argüman kontrolü
case "$1" in
help | -h | --help)
  show_help
  exit 0
  ;;
status)
  show_status
  exit 0
  ;;
esac

# Log yapılandırması
exec 1> >(tee -a "$LOG_FILE") 2>&1
echo "[$(date)] Hyprshade manager başlatılıyor..."

# Fonksiyon: Hyprshade durumunu kontrol et
check_hyprshade_status() {
  [ -f "$TOGGLE_FILE" ]
  return $?
}

# Fonksiyon: Hyprshade'i yönet
manage_hyprshade() {
  local force=${1:-false}
  local toggle=${2:-false}

  # Shader dosyasının varlığını kontrol et
  if [ ! -f "$SHADER_FILE" ]; then
    echo "[$(date)] HATA: Shader dosyası bulunamadı: $SHADER_FILE"
    notify-send -t 2000 -u critical "Hyprshade Hatası" "Kenp shader dosyası bulunamadı!"
    return 1
  fi

  # hyprshade'in yüklü olup olmadığını kontrol et
  if ! command -v hyprshade &>/dev/null; then
    echo "[$(date)] HATA: hyprshade yüklü değil!"
    return 1
  fi

  # Toggle modu için özel işlem
  if [ "$toggle" = true ]; then
    if check_hyprshade_status; then
      hyprshade off
      rm -f "$TOGGLE_FILE"
      notify-send -t 1000 -u low "Hyprshade Kapatıldı" "Hyprshade devre dışı"
      echo "[$(date)] Hyprshade devre dışı bırakıldı."
      return 0
    fi
  else
    CURRENT_TIME=$(date +%s)
    TIME_DIFF=$((CURRENT_TIME - LAST_RESTART))

    if [ "$force" = false ] && [ $TIME_DIFF -lt $MIN_WAIT ]; then
      echo "[$(date)] Son yeniden başlatmadan bu yana çok az zaman geçti ($TIME_DIFF saniye), işlem atlanıyor..."
      return 0
    fi
  fi

  # Eğer çalışıyorsa önce kapat
  hyprshade off
  sleep 0.5

  # (Yeniden) başlat
  hyprshade on "$SHADER_FILE"
  STATUS=$?

  if [ $STATUS -eq 0 ]; then
    touch "$TOGGLE_FILE"
    echo "[$(date)] Hyprshade başarıyla $([ "$force" = true ] && echo "başlatıldı" || echo "yeniden başlatıldı")"
    [ "$force" = true ] && notify-send -t 1000 -u low "Hyprshade Açıldı" "Hyprshade aktif"
    LAST_RESTART=$(date +%s)
    return 0
  else
    echo "[$(date)] HATA: Hyprshade $([ "$force" = true ] && echo "başlatılamadı" || echo "yeniden başlatılamadı") (kod: $STATUS)"
    return 1
  fi
}

# Ana işlem kontrolü
if [ "$1" = "toggle" ]; then
  manage_hyprshade false true
  exit $?
fi

# Hyprland'in başlamasını bekle
while ! pgrep -x "Hyprland" >/dev/null; do
  echo "[$(date)] Hyprland bekleniyor..."
  sleep 1
done

echo "[$(date)] Hyprland bulundu, servis başlatılıyor..."

# İlk başlatma
manage_hyprshade true

# Config değişikliklerini izleme ve servis başlatma
monitor_config_changes
