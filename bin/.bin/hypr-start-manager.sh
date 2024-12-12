#!/usr/bin/env bash

#===============================================================================
#
#   Version: 1.0.0
#   Date: 2024-12-10
#   Author: Kenan Pelit
#   Description: HyprFlow Start Manager
#
#   License: MIT
#
#===============================================================================

VERSION="1.0.0"
SCRIPT_NAME=$(basename "$0")

# Renk tanımları
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Hata durumunda çıkış yapacak fonksiyon
exit_with_error() {
  notify-send -u critical -t 5000 "Hata" "$1"
  echo -e "${RED}Hata: $1${NC}"
  exit 1
}

# Uygulama kontrolü yapan fonksiyon
check_application() {
  if ! command -v "$1" &>/dev/null; then
    exit_with_error "$1 uygulaması bulunamadı."
  fi
}

# Hyprland pencere kontrolü yapan fonksiyon
check_window() {
  local target_class="$1"
  local window_info

  window_info=$(hyprctl -j clients | jq -r ".[] | select(.class == \"$target_class\")")

  if [[ -n "$window_info" ]]; then
    hyprctl dispatch focuswindow "class:$target_class"
    notify-send "$target_class" "$target_class penceresine odaklanıldı."
    return 0
  fi
  return 1
}

# Süreç kontrolü yapan fonksiyon
check_process() {
  if pgrep -x "$1" >/dev/null; then
    return 0
  fi
  return 1
}

# Uygulamaları başlatma fonksiyonları
start_anote() {
  if hyprctl clients -j | jq -e '.[] | select(.class == "anotes")' >/dev/null; then
    window_address=$(hyprctl clients -j | jq -r '
        [.[] | select(.class == "anotes")] | 
        sort_by(.focusHistoryID) | 
        last | 
        .address
    ')
    current_workspace=$(hyprctl activewindow -j | jq -r '.workspace.id')
    hyprctl dispatch movetoworkspace "$current_workspace,address:$window_address"
    hyprctl dispatch focuswindow "address:$window_address"
    notify-send -t 1000 "Anote" "Mevcut Anote penceresine odaklanıldı."
  else
    alacritty --class anotes --title anotes -e ~/.bin/anote.sh >>/dev/null 2>&1 &
    disown
    notify-send -t 1000 "Anote" "Anote başlatılıyor..."
  fi
}

start_anotes() {
  if hyprctl clients -j | jq -e '.[] | select(.class == "anotes")' >/dev/null; then
    window_address=$(hyprctl clients -j | jq -r '
      [.[] | select(.class == "anotes")] | 
      sort_by(.focusHistoryID) | 
      last | 
      .address
    ')
    current_workspace=$(hyprctl activewindow -j | jq -r '.workspace.id')
    hyprctl dispatch movetoworkspace "$current_workspace,address:$window_address"
    hyprctl dispatch focuswindow "address:$window_address"
    notify-send -t 1000 "Anotes" "Mevcut Anotes penceresine odaklanıldı."
  else
    alacritty --class notes --title notes -e ~/.bin/anotes.sh >>/dev/null 2>&1 &
    disown
    notify-send -t 1000 "Anotes" "Anotes başlatılıyor..."
  fi
}

start_clock() {
  notify-send -t 1000 "Clock..." "Başlatılıyor..."
  GDK_BACKEND=wayland /usr/bin/kitty --class clock --title clock tty-clock -c -C7 >>/dev/null 2>&1 &
  disown
}

start_discord() {
  check_application "discord"
  notify-send -t 1000 "Discord Başlıyor..." "Uygulama başlatılıyor..."
  GDK_BACKEND=wayland /usr/bin/dicord -m >>/dev/null 2>&1 &
  disown
}

start_gsconnect() {
  if gapplication launch org.gnome.Shell.Extensions.GSConnect >>/dev/null 2>&1; then
    notify-send -t 1000 "GSConnect Başlatıldı" "GSConnect uygulaması başarıyla başlatıldı."
  else
    exit_with_error "GSConnect başlatılamadı."
  fi
}

start_keepassxc() {
  if ! check_window "org.keepassxc.KeePassXC"; then
    notify-send -t 1000 "KeePassXC" "KeePassXC başlatılıyor..."
    GDK_BACKEND=wayland /usr/bin/keepassxc >>/dev/null 2>&1 &
    disown
  fi
}

start_mpv() {
  if check_process "mpv"; then
    echo -e "${CYAN}MPV zaten çalışıyor.${NC} Pencere aktif hale getiriliyor."
    notify-send -i mpv -t 1000 "MPV Zaten Çalışıyor" "MPV aktif durumda, pencere öne getiriliyor."
    hyprctl dispatch focuswindow "class:mpv"
  else
    mpv --player-operation-mode=pseudo-gui --input-ipc-server=/tmp/mpvsocket -- >>/dev/null 2>&1 &
    disown
    notify-send -i mpv -t 1000 "MPV Başlatılıyor" "MPV oynatıcı başlatıldı ve hazır."
  fi
}

start_ncmpcpp() {
  # MPD durumunu kontrol et
  if ! pgrep -x mpd >/dev/null; then
    systemctl --user start mpd
    sleep 1
  fi

  # Hyprctl ile mevcut pencereyi kontrol et
  if ! hyprctl clients | grep -q "class: ncmpcpp"; then
    # Ncmpcpp'yi Kitty içinde başlat
    notify-send -t 1000 "Ncmpcpp" "Ncmpcpp başlatılıyor..."
    kitty \
      --class="ncmpcpp" \
      --title="ncmpcpp" \
      --override "initial_window_width=1000" \
      --override "initial_window_height=600" \
      --override "background_opacity=0.95" \
      --override "window_padding_width=15" \
      --override "hide_window_decorations=yes" \
      --override "font_size=13" \
      --override "confirm_os_window_close=0" \
      --config "$HOME/.config/kitty/kitty.conf" \
      -e ncmpcpp >>/dev/null 2>&1 &
    disown
  else
    # Varolan pencereye odaklan
    hyprctl dispatch focuswindow "^(ncmpcpp)$"
    notify-send -t 1000 "Ncmpcpp" "Mevcut pencereye odaklanıldı."
  fi
}

start_netflix() {
  check_application "netflix"
  notify-send -t 1000 "Netflix Başlıyor..." "Uygulama başlatılıyor..."
  GDK_BACKEND=wayland /usr/sbin/netflix >>/dev/null 2>&1 &
  disown
}

start_otpclient() {
  if check_process "otpclient"; then
    notify-send -u normal -t 1000 "OTPClient Zaten Çalışıyor" "OTPClient uygulaması zaten çalışıyor."
    return
  fi
  notify-send -t 1000 "OTPClient Başlatılıyor..." "OTPClient uygulaması başlatılıyor."
  GDK_BACKEND=wayland /usr/bin/otpclient >>/dev/null 2>&1 &
  disown
}

start_pavucontrol() {
  check_application "pavucontrol"
  notify-send -t 1000 "Pavucontrol..." "Uygulama başlatılıyor..."
  GDK_BACKEND=wayland /usr/bin/pavucontrol >>/dev/null 2>&1 &
  disown
}

start_ranger() {
  check_application "ranger"
  /usr/bin/alacritty --class Ranger -e "/usr/bin/ranger" >>/dev/null 2>&1 &
  disown
  notify-send -t 1000 "Ranger" "Ranger dosya yöneticisi başlatılıyor..."
}

start_spotify() {
  check_application "spotify"
  GDK_BACKEND=wayland /usr/bin/spotify >>/dev/null 2>&1 &
  disown
  notify-send -t 1000 "Spotify" "Spotify uygulaması başlatılıyor..."
}

start_tcopyb() {
  notify-send -t 1000 "Copy Manager" "Copy Manager (b) başlatılıyor..."
  kitty --class clipb --title clipb $HOME/.bin/tmux-copy.sh -b >>/dev/null 2>&1 &
  disown
}

start_tcopyc() {
  notify-send -t 1000 "Copy Manager" "Copy Manager (c) başlatılıyor..."
  kitty --class clipb --title clipb $HOME/.bin/tmux-copy.sh -c >>/dev/null 2>&1 &
  disown
}

start_thunar() {
  check_application "thunar"
  GDK_BACKEND=wayland /usr/bin/thunar >>/dev/null 2>&1 &
  disown
  notify-send -t 1000 "Thunar Başlatılıyor..." "Dosya yöneticisi başlatıldı."
}

start_todo() {
  check_application "todo"
  GDK_BACKEND=wayland /usr/bin/kitty --title todo --hold -e vim ~/.todo >>/dev/null 2>&1 &
  disown
  notify-send -t 1000 "Todo" "Todo uygulaması başlatılıyor..."
}

start_ulauncher() {
  check_application "ulauncher"
  GDK_BACKEND=wayland /usr/bin/ulauncher-toggle >>/dev/null 2>&1 &
  disown
}

start_webcord() {
  check_application "webcord"
  notify-send -t 1000 "WebCord Başlıyor..." "Uygulama başlatılıyor..."
  GDK_BACKEND=wayland /usr/bin/webcord -m >>/dev/null 2>&1 &
  disown
}

start_whatsapp() {
  check_application "zapzap"
  GDK_BACKEND=wayland /usr/bin/zapzap >>/dev/null 2>&1 &
  disown
  notify-send -t 1000 "WhatsApp" "ZapZap uygulaması başlatılıyor..."
}

# Yardım mesajını göster
show_help() {
  echo -e "${CYAN}HyprFlow Start Manager v$VERSION${NC}"
  echo "Kullanım: $SCRIPT_NAME [SEÇENEK]"
  echo ""
  echo "Seçenekler:"
  echo "  anote       - Anote başlat"
  echo "  anotes      - Anotes başlat"
  echo "  clock       - Terminal saati başlat"
  echo "  tcopyb      - Copy Manager (-b) başlat"
  echo "  tcopyc      - Copy Manager (-c) başlat"
  echo "  discord     - Discord başlat"
  echo "  gsconnect   - GSConnect başlat"
  echo "  keepassxc   - KeePassXC başlat"
  echo "  mpv         - MPV medya oynatıcı başlat"
  echo "  ncmpcpp     - Ncmpcpp müzik oynatıcı başlat"
  echo "  netflix     - Netflix başlat"
  echo "  otpclient   - OTPClient başlat"
  echo "  pavucontrol - Ses kontrol panelini başlat"
  echo "  ranger      - Ranger dosya yöneticisi başlat"
  echo "  spotify     - Spotify başlat"
  echo "  thunar      - Thunar dosya yöneticisi başlat"
  echo "  todo        - Todo uygulaması başlat"
  echo "  ulauncher   - Ulauncher başlat"
  echo "  webcord     - WebCord başlat"
  echo "  whatsapp    - WhatsApp (ZapZap) başlat"
  echo "  all         - Tüm uygulamaları başlat"
  echo "  --help, -h  - Bu yardım mesajını göster"
  echo "  --menu, -m  - Menü modunda çalıştır"
  echo ""
}

# Ana menü
show_menu() {
  echo -e "${CYAN}HyprFlow Start Manager v$VERSION${NC}"
  echo "================================"
  echo "1) Anote"
  echo "2) Anotes"
  echo "3) Clock"
  echo "4) Copy Manager (-b)"
  echo "5) Copy Manager (-c)"
  echo "6) Discord"
  echo "7) GSConnect"
  echo "8) KeePassXC"
  echo "9) MPV"
  echo "10) Ncmpcpp"
  echo "11) Netflix"
  echo "12) OTPClient"
  echo "12) Pavucontrol"
  echo "13) Ranger"
  echo "14) Spotify"
  echo "15) Thunar"
  echo "16) Todo"
  echo "17) Ulauncher"
  echo "18) WebCord"
  echo "19) WhatsApp"
  echo "20) Tüm uygulamaları başlat"
  echo "0) Çıkış"
  echo "================================"
  echo -n "Seçiminiz (0-20): "
}

# Tüm uygulamaları başlat
start_all() {
  echo -e "${CYAN}Tüm uygulamalar başlatılıyor...${NC}"
  start_anote
  start_anotes
  start_clock
  start_tcopyb
  start_tcopyc
  start_discord
  start_gsconnect
  start_keepassxc
  start_mpv
  start_ncmpcpp
  start_netflix
  start_otpclient
  start_pavucontrol
  start_ranger
  start_spotify
  start_thunar
  start_todo
  start_ulauncher
  start_webcord
  start_whatsapp
}

# Menü modu
menu_mode() {
  while true; do
    clear
    show_menu
    read -r choice

    case $choice in
    0)
      echo "Çıkış yapılıyor..."
      break
      ;;
    1) start_anote ;;
    2) start_anotes ;;
    3) start_clock ;;
    4) start_tcopyb ;;
    5) start_tcopyc ;;
    6) start_discord ;;
    7) start_gsconnect ;;
    8) start_keepassxc ;;
    9) start_mpv ;;
    10) start_ncmpcpp ;;
    11) start_netflix ;;
    12) start_otpclient ;;
    13) start_pavucontrol ;;
    14) start_ranger ;;
    15) start_spotify ;;
    16) start_thunar ;;
    17) start_todo ;;
    18) start_ulauncher ;;
    19) start_webcord ;;
    20) start_whatsapp ;;
    21) start_all ;;
    *)
      echo "Geçersiz seçim! Lütfen 0-21 arası bir sayı girin."
      sleep 2
      ;;
    esac
  done
}

# Ana program
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

case "$1" in
"anote") start_anote ;;
"anotes") start_anotes ;;
"clock") start_clock ;;
"tcopyb") start_tcopyb ;;
"tcopyc") start_tcopyc ;;
"discord") start_discord ;;
"gsconnect") start_gsconnect ;;
"keepassxc") start_keepassxc ;;
"mpv") start_mpv ;;
"ncmpcpp") start_ncmpcpp ;;
"netflix") start_netflix ;;
"otpclient") start_otpclient ;;
"pavucontrol") start_pavucontrol ;;
"ranger") start_ranger ;;
"spotify") start_spotify ;;
"thunar") start_thunar ;;
"todo") start_todo ;;
"ulauncher") start_ulauncher ;;
"webcord") start_webcord ;;
"whatsapp") start_whatsapp ;;
"all") start_all ;;
"--help" | "-h") show_help ;;
"--menu" | "-m") menu_mode ;;
*)
  echo "Geçersiz parametre: $1"
  show_help
  exit 1
  ;;
esac

exit 0
