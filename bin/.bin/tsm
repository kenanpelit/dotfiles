#!/bin/bash
#######################################
#
# Version: 1.0.0
# Date: 2024-12-12
# Author: Kenan Pelit
# Repository: github.com/kenanpelit/dotfiles
# Description: TransmissionCLI - Transmission Terminal Yönetim Aracı
#
# Bu script transmission-remote için bir CLI arayüzü sağlar.
# Temel özellikleri:
# - Pass entegrasyonu ile güvenli kimlik bilgileri yönetimi
# - Torrent ekleme (magnet/dosya)
# - Torrent listeleme ve yönetim
# - Detaylı torrent bilgileri görüntüleme
# - Toplu torrent yönetimi (start/stop/remove)
# - Hız izleme ve dosya listeleme
#
# Komutlar:
# - add: Torrent/magnet ekle
# - list: Torrent listele
# - start/stop: Torrent başlat/durdur
# - remove/purge: Torrent sil
# - info: Torrent detayları
# - speed: Hız bilgisi
# - files: Dosya listesi
# - config: Yapılandırma
#
# Gereksinimler:
# - pass (şifre yöneticisi)
# - transmission-remote
#
# License: MIT
#
#######################################
# Renk kodları
Color_Off='\e[0m'
Red='\e[0;31m'
Green='\e[0;32m'
Yellow='\e[0;33m'
Blue='\e[0;34m'

# Pass'dan bilgileri al
if ! command -v pass &>/dev/null; then
  echo -e "${Red}Error: 'pass' komutu bulunamadı. Lütfen pass'ı yükleyin.${Color_Off}"
  exit 1
fi

# Pass'dan kullanıcı adı ve şifreyi al, yoksa oluştur
if ! pass show tsm-user &>/dev/null; then
  read -p "Transmission kullanıcı adı (varsayılan: admin): " username
  username=${username:-admin}
  echo "$username" | pass insert -e tsm-user
fi

if ! pass show tsm-pass &>/dev/null; then
  read -sp "Transmission şifresi: " password
  echo
  echo "$password" | pass insert -e tsm-pass
fi

username=$(pass show tsm-user)
password=$(pass show tsm-pass)

# Transmission-remote temel komutu
TR_CMD="transmission-remote --auth $username:$password"

# Yardım mesajı
show_help() {
  echo -e "${Blue}Transmission Terminal Yöneticisi${Color_Off}"
  echo "Kullanım: tsm.sh [komut] [parametre]"
  echo
  echo "Komutlar:"
  echo -e "${Green}add${Color_Off} [link/dosya]    Torrent veya magnet link ekle"
  echo -e "${Green}list${Color_Off}                Torrent listesini göster"
  echo -e "${Green}start${Color_Off} [id]          Torrenti başlat"
  echo -e "${Green}stop${Color_Off} [id]           Torrenti durdur"
  echo -e "${Green}remove${Color_Off} [id]         Torrenti sil"
  echo -e "${Green}purge${Color_Off} [id]          Torrenti ve dosyaları sil"
  echo -e "${Green}info${Color_Off} [id]           Torrent detaylarını göster"
  echo -e "${Green}speed${Color_Off}               İndirme/yükleme hızını göster"
  echo -e "${Green}files${Color_Off} [id]          Torrent dosyalarını listele"
  echo -e "${Green}config${Color_Off}              Kullanıcı adı ve şifreyi yeniden ayarla"
  echo
  echo "Örnekler:"
  echo "  tsm.sh add magnet:?xt=urn:btih:..."
  echo "  tsm.sh add ubuntu.torrent"
  echo "  tsm.sh list"
  echo "  tsm.sh start 1"
  echo "  tsm.sh stop all"
}

# Torrent listesini göster
show_list() {
  echo -e "${Blue}Torrent Listesi:${Color_Off}"
  $TR_CMD -l
}

# Yapılandırmayı yeniden ayarla
reconfigure() {
  read -p "Yeni kullanıcı adı (varsayılan: admin): " new_username
  new_username=${new_username:-admin}
  echo "$new_username" | pass insert -f -e tsm-user

  read -sp "Yeni şifre: " new_password
  echo
  echo "$new_password" | pass insert -f -e tsm-pass

  echo -e "${Green}Yapılandırma güncellendi.${Color_Off}"
}

case "$1" in
"add")
  if [ -z "$2" ]; then
    echo -e "${Red}Hata: Torrent dosyası veya magnet link gerekli${Color_Off}"
    exit 1
  fi
  echo -e "${Yellow}Torrent ekleniyor...${Color_Off}"
  $TR_CMD -a "$2"
  ;;
"list")
  show_list
  ;;
"start")
  if [ "$2" = "all" ]; then
    echo -e "${Yellow}Tüm torrentler başlatılıyor...${Color_Off}"
    $TR_CMD -t all -s
  elif [ -n "$2" ]; then
    echo -e "${Yellow}$2 ID'li torrent başlatılıyor...${Color_Off}"
    $TR_CMD -t "$2" -s
  else
    echo -e "${Red}Hata: Torrent ID'si gerekli${Color_Off}"
    exit 1
  fi
  ;;
"stop")
  if [ "$2" = "all" ]; then
    echo -e "${Yellow}Tüm torrentler durduruluyor...${Color_Off}"
    $TR_CMD -t all -S
  elif [ -n "$2" ]; then
    echo -e "${Yellow}$2 ID'li torrent durduruluyor...${Color_Off}"
    $TR_CMD -t "$2" -S
  else
    echo -e "${Red}Hata: Torrent ID'si gerekli${Color_Off}"
    exit 1
  fi
  ;;
"remove")
  if [ "$2" = "all" ]; then
    echo -e "${Red}Tüm torrentler siliniyor...${Color_Off}"
    $TR_CMD -t all -r
  elif [ -n "$2" ]; then
    echo -e "${Red}$2 ID'li torrent siliniyor...${Color_Off}"
    $TR_CMD -t "$2" -r
  else
    echo -e "${Red}Hata: Torrent ID'si gerekli${Color_Off}"
    exit 1
  fi
  ;;
"purge")
  if [ "$2" = "all" ]; then
    echo -e "${Red}Tüm torrentler ve dosyaları siliniyor...${Color_Off}"
    $TR_CMD -t all -rad
  elif [ -n "$2" ]; then
    echo -e "${Red}$2 ID'li torrent ve dosyaları siliniyor...${Color_Off}"
    $TR_CMD -t "$2" -rad
  else
    echo -e "${Red}Hata: Torrent ID'si gerekli${Color_Off}"
    exit 1
  fi
  ;;
"info")
  if [ -n "$2" ]; then
    echo -e "${Blue}$2 ID'li torrent detayları:${Color_Off}"
    $TR_CMD -t "$2" -i
  else
    echo -e "${Red}Hata: Torrent ID'si gerekli${Color_Off}"
    exit 1
  fi
  ;;
"speed")
  echo -e "${Blue}Anlık hız bilgisi:${Color_Off}"
  $TR_CMD -si
  ;;
"files")
  if [ -n "$2" ]; then
    echo -e "${Blue}$2 ID'li torrent dosyaları:${Color_Off}"
    $TR_CMD -t "$2" -f
  else
    echo -e "${Red}Hata: Torrent ID'si gerekli${Color_Off}"
    exit 1
  fi
  ;;
"config")
  reconfigure
  ;;
*)
  show_help
  ;;
esac
