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

sleep=3

service_exists() {
  local n="hyprshade"
  if [[ $(systemctl --user list-units --all -t service --full --no-legend "$n.service" | sed 's/^\s*//g' | cut -f1 -d' ') == $n.service ]]; then
    return 0
  else
    return 1
  fi
}
# Hyprland'in başlamasını bekle
while ! pgrep -x "Hyprland" >/dev/null; do
  sleep 1
done
# Kısa bir bekleme süresi
sleep $sleep
if service_exists; then
  echo "Hyprshade service bulundu, başlatılıyor..."
  systemctl --user restart hyprshade.service
else
  echo "HATA: Hyprshade service bulunamadı!"
  notify-send -u critical "Hyprshade" "Service bulunamadı!"
fi
