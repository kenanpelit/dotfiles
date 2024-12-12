#!/bin/bash
########################################
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
# MPV Manager Script
# Hyprland masaüstü ortamında MPV pencere ve video yönetimi için kapsamlı bir araç.
#
# Özellikler:
# - MPV penceresini köşeler arasında döndürme
# - Pencere sabitleme
# - Oynatma/duraklatma kontrolü
# - YouTube videolarını doğrudan oynatma
# - Videoları duvar kağıdı olarak ayarlama
#
# Gereksinimler:
# - mpv
# - hyprctl (Hyprland)
# - jq
# - socat
# - wl-clipboard
# - yt-dlp (YouTube videoları için)
# - libnotify (bildirimler için)
# - pulseaudio-utils (ses bildirimleri için)

# Renk tanımları
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Kullanım bilgisini göster
usage() {
  echo "Kullanım: $0 [komut]"
  echo "Komutlar:"
  echo "  cycle    - MPV penceresini köşeler arasında döndür"
  echo "  pin      - MPV penceresini sabitle"
  echo "  toggle   - Oynatmayı duraklat/devam ettir"
  echo "  yplay    - YouTube URL'sini oynat (clipboard'dan alır)"
  echo "  wallplay - Video'yu duvar kağıdı olarak oynat (clipboard'dan alır)"
  exit 1
}

# MPV'nin çalışıp çalışmadığını kontrol et
check_mpv_running() {
  if ! pgrep -x "mpv" >/dev/null; then
    echo -e "${RED}MPV oynatıcı çalışmıyor. Lütfen önce MPV'yi başlatın.${NC}"
    exit 1
  fi
}

# Köşeler arasında döndürme fonksiyonu
cycle_corners() {
  if hyprctl clients -j | jq -e '.[] | select(.class == "mpv")' >/dev/null; then
    hyprctl dispatch focuswindow mpv

    # Pencere pozisyonunu al
    x_pos=$(hyprctl clients -j | jq -r '.[] | select(.class == "mpv") | .at[0]')
    y_pos=$(hyprctl clients -j | jq -r '.[] | select(.class == "mpv") | .at[1]')

    # Pencere boyutunu al
    size=$(hyprctl clients -j | jq -r '.[] | select(.class == "mpv") | .size[0]')

    # Büyük pencere (19%) için konumlar
    if [ "$size" -gt "300" ]; then
      if [ "$x_pos" -lt "500" ] && [ "$y_pos" -lt "500" ]; then
        hyprctl dispatch moveactive exact 80% 7%
      elif [ "$x_pos" -gt "1000" ] && [ "$y_pos" -lt "500" ]; then
        hyprctl dispatch moveactive exact 80% 77%
      elif [ "$x_pos" -gt "1000" ] && [ "$y_pos" -gt "500" ]; then
        hyprctl dispatch moveactive exact 1% 77%
      else
        hyprctl dispatch moveactive exact 1% 7%
      fi
    # Küçük pencere (15%) için konumlar
    else
      if [ "$x_pos" -lt "500" ] && [ "$y_pos" -lt "500" ]; then
        hyprctl dispatch moveactive exact 84% 7%
      elif [ "$x_pos" -gt "1000" ] && [ "$y_pos" -lt "500" ]; then
        hyprctl dispatch moveactive exact 84% 80%
      elif [ "$x_pos" -gt "1000" ] && [ "$y_pos" -gt "500" ]; then
        hyprctl dispatch moveactive exact 3% 80%
      else
        hyprctl dispatch moveactive exact 3% 7%
      fi
    fi
  fi
}

# Pencereyi sabitleme fonksiyonu
pin_window() {
  hyprctl dispatch pin mpv
  notify-send -t 1000 "MPV pin completed! 🔥"
}

# Oynatma/duraklatma döngüsü fonksiyonu
toggle_play_pause() {
  check_mpv_running

  # MPV'nin duraklatılmış olup olmadığını kontrol et
  status=$(echo '{ "command": ["get_property", "pause"] }' | socat - /tmp/mpvsocket | grep -o '"data":true')

  if [ "$status" = '"data":true' ]; then
    # MPV duraklatılmış, devam ettirme komutunu gönder
    echo '{ "command": ["cycle", "pause"] }' | socat - /tmp/mpvsocket | grep -o '"error":"success"' >/dev/null
    echo -e "${GREEN}MPV Devam ettiriliyor.${NC}"
    notify-send -i mpv -t 2000 "MPV" "Devam ettiriliyor"
  else
    # MPV oynatılıyor, duraklatma komutunu gönder
    echo '{ "command": ["cycle", "pause"] }' | socat - /tmp/mpvsocket | grep -o '"error":"success"' >/dev/null
    echo -e "${GREEN}MPV Duraklatılıyor.${NC}"
    notify-send -i mpv -t 2000 "MPV" "Duraklatılıyor"
  fi
}

# YouTube video oynatma fonksiyonu
play_youtube() {
  VIDEO_URL="$(wl-paste)"

  # YouTube URL'si olup olmadığını kontrol et
  if ! [[ "$VIDEO_URL" =~ ^https?://(www\.)?(youtube\.com|youtu\.?be)/ ]]; then
    notify-send -t 5000 "Error" "Kopyalanan URL geçerli bir YouTube URL'si değil."
    exit 1
  fi

  # Video adını al
  VIDEO_NAME=$(yt-dlp --get-title "$VIDEO_URL" 2>/dev/null)
  if [[ -z "$VIDEO_NAME" ]]; then
    VIDEO_NAME=$(basename "$VIDEO_URL")
  fi

  notify-send -t 5000 "Playing Video" "$VIDEO_NAME"
  paplay /usr/share/sounds/freedesktop/stereo/message.oga &

  if ! wait $!; then
    notify-send -t 5000 "Audio Error" "Ses dosyası çalamadı."
  else
    sleep 1
  fi

  /usr/bin/mpv --player-operation-mode=pseudo-gui \
    --input-ipc-server=/tmp/mpvsocket \
    --idle \
    --no-audio-display \
    --speed=1 \
    --af=rubberband=pitch-scale=0.981818181818181 \
    "$VIDEO_URL" &

  sleep 15

  CLIENT_INFO=$(hyprctl clients | grep -A 10 "mpv:")
  WORKSPACE=$(echo "$CLIENT_INFO" | grep "workspace:" | awk '{print $2}' | tr -d '()')
  notify-send -t 10000 "Current Desktop" "Video is playing on workspace: $WORKSPACE"
}

# Duvar kağıdı olarak video oynatma fonksiyonu
play_as_wallpaper() {
  notify-send -t 5000 "Playing Video Mpvpaper" "$(wl-paste)"
  /usr/bin/mpvpaper "eDP-1" "$(wl-paste)"
}

# Ana script mantığı
case "$1" in
"cycle")
  cycle_corners
  ;;
"pin")
  pin_window
  ;;
"toggle")
  toggle_play_pause
  ;;
"yplay")
  play_youtube
  ;;
"wallplay")
  play_as_wallpaper
  ;;
*)
  usage
  ;;
esac
