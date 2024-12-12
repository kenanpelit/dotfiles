#!/bin/bash

#######################################
#
# Version: 2.0.0
# Date: 2024-12-12
# Author: Kenan Pelit
# Repository: github.com/kenanpelit/dotfiles
# Description: Session Manager (sem) - Terminal ve Uygulama Oturumları Yönetici
#
# Bu script Unix/Linux sistemlerde uygulama oturumlarını yönetmek için
# tasarlanmıştır. Temel özellikleri:
# - VPN (Mullvad) entegrasyonu ve oturum bazlı VPN yönetimi
# - JSON tabanlı yapılandırma sistemi
# - Oturum başlatma/durdurma/yeniden başlatma
# - CPU ve bellek kullanımı izleme
# - JSON formatında metrik toplama
# - Güvenli dosya izinleri ve hata yönetimi
#
# Config: ~/.config/sem/config.json
# Logs: ~/.config/sem/logs/sem.log
# PID: /tmp/sem/
#
# License: MIT
#
#######################################

# Yapılandırma
config_file="${XDG_CONFIG_HOME:-$HOME/.config}/sem/config.json"
scripts_dir="$HOME/.bin/start-scripts"
SEMSUMO_PATH="/home/kenan/.bin/semsumo.sh"

# Dizin kontrol
if [[ ! -f "$config_file" ]]; then
  echo "Config dosyası bulunamadı: $config_file"
  exit 1
fi

# Scripts dizinini oluştur
mkdir -p "$scripts_dir"
echo "Script oluşturma başlıyor..."
echo "--------------------------"

# Her profil için scriptleri oluştur
jq -r '.sessions | keys[]' "$config_file" | while read -r profile; do
  echo "Profil işleniyor: $profile"

  # Her mod için ayrı script
  for mode in always never default; do
    script_file="$scripts_dir/start-${profile,,}-${mode}.sh"
    cat >"$script_file" <<EOF
#!/bin/bash
$SEMSUMO_PATH start $profile $mode
EOF
    chmod +x "$script_file"
    echo "  ✓ Oluşturuldu: start-${profile,,}-${mode}.sh"
  done
  echo ""
done

echo "--------------------------"
echo "Script oluşturma tamamlandı!"
echo "Kullanım örnekleri:"
echo "  $scripts_dir/start-zen-kenp-always.sh"
echo "  $scripts_dir/start-zen-kenp-never.sh"
echo "  $scripts_dir/start-zen-kenp-default.sh"
