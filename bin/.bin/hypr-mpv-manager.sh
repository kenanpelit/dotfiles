#!/bin/bash
########################################
#
# Version: 1.1.0
# Date: 2024-12-20
# Author: Kenan Pelit
# Repository: github.com/kenanpelit/dotfiles
# Description: HyprFlow - MPV Yönetim Aracı
#
# License: MIT
#
#######################################
# HyprFlow - MPV Yönetim Aracı
# Hyprland masaüstü ortamında MPV pencere ve medya yönetimi için kapsamlı bir araç.
#
# Özellikler:
# - Akıllı pencere konumlandırma ve döndürme
# - Pencere sabitleme ve odaklama
# - Medya kontrolü (oynat/duraklat)
# - YouTube video yönetimi (oynatma ve indirme)
# - Canlı duvar kağıdı desteği
#
# Gereksinimler:
# - mpv: Medya oynatıcı
# - hyprctl: Hyprland pencere yönetimi
# - jq: JSON işleme
# - socat: Socket iletişimi
# - wl-clipboard: Pano yönetimi
# - yt-dlp: YouTube video indirme
# - libnotify: Masaüstü bildirimleri
# - pulseaudio-utils: Ses bildirimleri
#
########################################

# Renk ve sembol tanımları
SUCCESS='\033[0;32m'
ERROR='\033[0;31m'
INFO='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
CHECK_MARK="✓"
CROSS_MARK="✗"
ARROW_MARK="→"

# Yapılandırma değişkenleri
SOCKET_PATH="/tmp/mpvsocket"
DOWNLOADS_DIR="$HOME/Downloads"
NOTIFICATION_TIMEOUT=3000
SOUND_THEME_PATH="/usr/share/sounds/freedesktop/stereo"

# Kullanım kılavuzu
show_usage() {
  cat <<EOF
HyprFlow - MPV Yönetim Aracı v1.1.0

Kullanım: $(basename "$0") <komut>

Komutlar:
    start       MPV'yi başlat veya aktif hale getir
    move        MPV penceresini akıllıca konumlandır
    stick       Pencereyi bulunduğu konuma sabitle/sabitlemeyi kaldır
    playback    Medya oynatımını duraklat/devam ettir
    play-yt     Panodaki YouTube URL'sini oynat
    save-yt     Panodaki YouTube videosunu indir
    wallpaper   Panodaki video/URL'yi duvar kağıdı yap

Örnekler:
    $(basename "$0") move        # Pencereyi bir sonraki köşeye taşır
    $(basename "$0") play-yt     # Kopyalanan YouTube linkini oynatır
EOF
  exit 1
}

# Hata mesajı gösterme
show_error() {
  echo -e "${ERROR}$CROSS_MARK Hata: $1${NC}" >&2
  notify-send -u critical -t $NOTIFICATION_TIMEOUT "HyprFlow Hata" "$1"
  paplay "$SOUND_THEME_PATH/dialog-error.oga" &>/dev/null &
  exit 1
}

# Başarı mesajı gösterme
show_success() {
  echo -e "${SUCCESS}$CHECK_MARK $1${NC}"
  notify-send -t $NOTIFICATION_TIMEOUT "HyprFlow" "$1"
  paplay "$SOUND_THEME_PATH/complete.oga" &>/dev/null &
}

# Bilgi mesajı gösterme
show_info() {
  echo -e "${INFO}$ARROW_MARK $1${NC}"
  notify-send -t $NOTIFICATION_TIMEOUT "HyprFlow" "$1"
}

# Proses kontrolü
check_process() {
  local process_name="$1"
  pgrep -x "$process_name" >/dev/null
}

# MPV durumunu kontrol et
check_mpv() {
  if ! check_process "mpv"; then
    show_error "MPV çalışmıyor"
    return 1
  fi
  return 0
}

# YouTube URL kontrolü
validate_youtube_url() {
  local url="$1"
  if ! [[ "$url" =~ ^https?://(www\.)?(youtube\.com|youtu\.?be)/ ]]; then
    show_error "Geçersiz YouTube URL'si: $url"
    return 1
  fi
  return 0
}

# MPV'yi başlat veya aktif hale getir
start_mpv() {
  local window_info
  window_info=$(hyprctl clients -j | jq '.[] | select(.initialClass == "mpv")')

  if [ -n "$window_info" ]; then
    local window_address
    window_address=$(echo "$window_info" | jq -r '.address')

    echo -e "${CYAN}MPV zaten çalışıyor.${NC} Pencere aktif hale getiriliyor."
    notify-send -i mpv -t 1000 "MPV Zaten Çalışıyor" "MPV aktif durumda, pencere öne getiriliyor."
    hyprctl dispatch focuswindow "address:$window_address"
  else
    mpv --player-operation-mode=pseudo-gui --input-ipc-server=/tmp/mpvsocket -- >>/dev/null 2>&1 &
    disown
    notify-send -i mpv -t 1000 "MPV Başlatılıyor" "MPV oynatıcı başlatıldı ve hazır."
  fi
}

# Pencere konumunu değiştir
move_window() {
  # MPV penceresini bul ve adresini al
  local window_info
  window_info=$(hyprctl clients -j | jq '.[] | select(.initialClass == "mpv")')

  if [ -z "$window_info" ]; then
    show_error "MPV penceresi bulunamadı"
    return 1
  fi

  # Pencere adresini al
  local window_address
  window_address=$(echo "$window_info" | jq -r '.address')

  # Önce pencereyi aktif hale getir
  hyprctl dispatch focuswindow "address:$window_address"
  sleep 0.1 # Pencere aktivasyonu için kısa bir bekleme

  # Pencere pozisyonunu al
  local x_pos
  x_pos=$(echo "$window_info" | jq -r '.at[0]')
  local y_pos
  y_pos=$(echo "$window_info" | jq -r '.at[1]')
  local size
  size=$(echo "$window_info" | jq -r '.size[0]')

  # Pencere boyutuna göre konumlandırma
  if [ "$size" -gt "300" ]; then
    # Büyük pencere konumları (%19)
    if [ "$x_pos" -lt "500" ] && [ "$y_pos" -lt "500" ]; then
      hyprctl dispatch moveactive exact 80% 7%
    elif [ "$x_pos" -gt "1000" ] && [ "$y_pos" -lt "500" ]; then
      hyprctl dispatch moveactive exact 80% 77%
    elif [ "$x_pos" -gt "1000" ] && [ "$y_pos" -gt "500" ]; then
      hyprctl dispatch moveactive exact 1% 77%
    else
      hyprctl dispatch moveactive exact 1% 7%
    fi
  else
    # Küçük pencere konumları (%15)
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

  show_success "Pencere konumu güncellendi"
}

# Pencereyi sabitle/sabitlemeyi kaldır
toggle_stick() {
  check_mpv || return 1
  hyprctl dispatch pin mpv
  show_success "Pencere durumu değiştirildi"
}

# Oynatma durumunu değiştir
toggle_playback() {
  check_mpv || return 1

  # MPV'nin mevcut durumunu kontrol et
  local status
  status=$(echo '{ "command": ["get_property", "pause"] }' | socat - "$SOCKET_PATH" | grep -o '"data":true')

  if [ "$status" = '"data":true' ]; then
    echo '{ "command": ["cycle", "pause"] }' | socat - "$SOCKET_PATH" >/dev/null
    show_success "Oynatma devam ediyor"
  else
    echo '{ "command": ["cycle", "pause"] }' | socat - "$SOCKET_PATH" >/dev/null
    show_success "Oynatma duraklatıldı"
  fi
}

# YouTube videosu oynat
play_youtube() {
  local video_url
  video_url=$(wl-paste)
  validate_youtube_url "$video_url" || return 1

  # Video başlığını al
  local video_title
  video_title=$(yt-dlp --get-title "$video_url" 2>/dev/null || echo "Video")
  show_info "Oynatılıyor: $video_title"

  # MPV ile oynat
  /usr/bin/mpv \
    --player-operation-mode=pseudo-gui \
    --input-ipc-server="$SOCKET_PATH" \
    --idle \
    --no-audio-display \
    --speed=1 \
    --af=rubberband=pitch-scale=0.981818181818181 \
    "$video_url" &

  # Çalışma alanı bilgisini göster
  sleep 2
  local workspace
  workspace=$(hyprctl clients | grep -A 10 "mpv:" | grep "workspace:" | awk '{print $2}' | tr -d '()')
  show_info "Video $workspace numaralı çalışma alanında oynatılıyor"
}

# YouTube videosu indir
download_youtube() {
  local video_url
  video_url=$(wl-paste)
  validate_youtube_url "$video_url" || return 1

  # Video başlığını al
  local video_title
  video_title=$(yt-dlp --get-title "$video_url" 2>/dev/null || echo "Video")
  show_info "İndiriliyor: $video_title"

  # İndirme klasörüne git
  cd "$DOWNLOADS_DIR" || show_error "İndirme klasörüne erişilemiyor"

  # En iyi kalitede indir
  if yt-dlp -f "bestvideo+bestaudio/best" \
    --merge-output-format mp4 \
    --embed-thumbnail \
    --add-metadata \
    "$video_url"; then
    show_success "Video başarıyla indirildi: $video_title"
  else
    show_error "Video indirilemedi: $video_title"
  fi
}

# Duvar kağıdı olarak oynat
set_video_wallpaper() {
  local video_path
  video_path=$(wl-paste)
  show_info "Duvar kağıdı ayarlanıyor..."

  if /usr/bin/mpvpaper "eDP-1" "$video_path"; then
    show_success "Duvar kağıdı ayarlandı"
  else
    show_error "Duvar kağıdı ayarlanamadı"
  fi
}

# Ana program
main() {
  case "$1" in
  "start")
    start_mpv
    ;;
  "move")
    move_window
    ;;
  "stick")
    toggle_stick
    ;;
  "playback")
    toggle_playback
    ;;
  "play-yt")
    play_youtube
    ;;
  "save-yt")
    download_youtube
    ;;
  "wallpaper")
    set_video_wallpaper
    ;;
  *)
    show_usage
    ;;
  esac
}

# Programı çalıştır
main "$@"

