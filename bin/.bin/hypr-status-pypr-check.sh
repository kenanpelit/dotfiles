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

# Servisi her 180 saniyede bir kontrol etmek için bekleme süresi
check_interval=180 # 180 saniye

service_exists() {
  local n=$1
  if [[ $(systemctl --user list-units --all -t service --full --no-legend "$n.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "$n.service" ]]; then
    return 0
  else
    return 1
  fi
}

# Servis çalışıyor mu kontrol et
service_active() {
  local n=$1
  if systemctl --user is-active --quiet "$n.service"; then
    return 0
  else
    return 1
  fi
}

# pypr servisini her 180 saniyede bir kontrol et ve gerekiyorsa başlat
while true; do
  if service_exists pypr; then
    if ! service_active pypr; then
      echo "pypr servisi çalışmıyor, başlatılıyor..."
      systemctl --user start pypr
    else
      echo "pypr servisi zaten çalışıyor."
    fi
  else
    echo "pypr servisi bulunamadı!"
  fi
  sleep "$check_interval"
done
