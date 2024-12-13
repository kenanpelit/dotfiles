#!/bin/bash
# ===================================================================================
# Arch Linux Paket Kurulum ve Yapılandırma Scripti
# ===================================================================================
# Bu script:
# 1. Sistem paket yöneticisini (pacman veya paru) tespit eder
# 2. /etc/pacman.conf dosyasını yedekler ve yeni yapılandırmayı uygular
# 3. all_packages.txt dosyasından paketleri okur ve kurulumlarını gerçekleştirir
# 4. Kurulum sürecini detaylı olarak loglar ve özet rapor sunar
# ===================================================================================

# Renk kodları
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Renk yok

# Onay alma fonksiyonu
get_confirmation() {
  local message=$1
  while true; do
    echo -e -n "${YELLOW}$message [e/h]: ${NC}"
    read -r response
    case "$response" in
    [Ee]) return 0 ;;
    [Hh]) return 1 ;;
    *) echo -e "${RED}Lütfen 'e' veya 'h' girin.${NC}" ;;
    esac
  done
}

# pacman.conf yedekleme ve güncelleme fonksiyonu
update_pacman_conf() {
  local backup_date=$(date +%Y%m%d_%H%M%S)
  local backup_file="/etc/pacman.conf_$backup_date"

  echo -e "${BLUE}=== Pacman Yapılandırması Güncellemesi ===${NC}"
  echo -e "Bu işlem:"
  echo -e "1. Mevcut pacman.conf dosyasını '${CYAN}$backup_file${NC}' olarak yedekleyecek"
  echo -e "2. Yeni yapılandırmayı uygulayacak"
  echo -e "3. Chaotic-AUR, ArcoLinux ve diğer depoları ekleyecek\n"

  if ! get_confirmation "Devam etmek istiyor musunuz?"; then
    echo -e "${RED}pacman.conf güncelleme işlemi iptal edildi${NC}"
    return 1
  fi

  echo -e "\n${YELLOW}pacman.conf dosyası yedekleniyor...${NC}"
  if sudo cp /etc/pacman.conf "$backup_file"; then
    echo -e "${GREEN}Yedekleme başarılı: $backup_file${NC}"
  else
    echo -e "${RED}Yedekleme başarısız!${NC}"
    return 1
  fi

  # Yeni pacman.conf içeriği
  cat <<'EOL' | sudo tee /etc/pacman.conf >/dev/null
#
# /etc/pacman.conf
#
# See the pacman.conf(5) manpage for option and repository directives
#
# GENERAL OPTIONS
#
[options]
# The following paths are commented out with their default values listed.
# If you wish to use different paths, uncomment and update the paths.
#RootDir     = /
#DBPath      = /var/lib/pacman/
#CacheDir    = /var/cache/pacman/pkg/
#LogFile     = /var/log/pacman.log
#GPGDir      = /etc/pacman.d/gnupg/
#HookDir     = /etc/pacman.d/hooks/
HoldPkg      = pacman glibc
#XferCommand = /usr/bin/curl -L -C - -f -o %o %u
#XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
#CleanMethod = KeepInstalled
Architecture = auto
#IgnorePkg   = ttf-google-fonts-git tmux hyprland-git hyprland
#IgnorePkg   =
#IgnoreGroup =
#NoUpgrade   =
#NoExtract   =
# Misc options
#UseSyslog
Color
#NoProgressBar
CheckSpace
VerbosePkgLists
ParallelDownloads = 5
ILoveCandy
DisableDownloadTimeout
# By default, pacman accepts packages signed by keys that its local keyring
# trusts (see pacman-key and its man page), as well as unsigned packages.
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional
#RemoteFileSigLevel = Required
# NOTE: You must run `pacman-key --init` before first using pacman; the local
# keyring can then be populated with the keys of all official Arch Linux
# packagers with `pacman-key --populate archlinux`.
#
# REPOSITORIES
#   - can be defined here or included from another file
#   - pacman will search repositories in the order defined here
#   - local/custom mirrors can be added here or in separate files
#   - repositories listed first will take precedence when packages
#     have identical names, regardless of version number
#   - URLs will have $repo replaced by the name of the current repo
#   - URLs will have $arch replaced by the name of the architecture
#
# Repository entries are of the format:
#       [repo-name]
#       Server = ServerName
#       Include = IncludePath
#
# The header [repo-name] is crucial - it must be present and
# uncommented to enable the repo.
#
# The testing repositories are disabled by default. To enable, uncomment the
# repo name header and Include lines. You can add preferred servers immediately
# after the header, and they will be used before the default mirrors.
#[arcolinux_repo_testing]
#SigLevel = Required DatabaseOptional
#Include = /etc/pacman.d/arcolinux-mirrorlist
# En yüksek öncelikli repolar üstte olmalı
[core]
Include = /etc/pacman.d/mirrorlist
[extra]
Include = /etc/pacman.d/mirrorlist
[community]
Include = /etc/pacman.d/mirrorlist
[multilib]
Include = /etc/pacman.d/mirrorlist
[chaotic-aur]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/chaotic-mirrorlist
[arcolinux_repo]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/arcolinux-mirrorlist
[arcolinux_repo_3party]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/arcolinux-mirrorlist
[arcolinux_repo_xlarge]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/arcolinux-mirrorlist
# If you want to run 32 bit applications on your x86_64 system,
# enable the multilib repositories as required here.
#[multilib-testing]
#Include = /etc/pacman.d/mirrorlist
# An example of a custom package repository.  See the pacman manpage for
# tips on creating your own repositories.
#[custom]
#SigLevel = Optional TrustAll
#Server = file:///home/custompkgs
EOL

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}pacman.conf başarıyla güncellendi${NC}"
    echo "pacman.conf güncellendi - Yedek: $backup_file - $(date)" >>$LOG_FILE
    echo -e "\n${BLUE}Yapılan değişiklikler:${NC}"
    echo -e "1. Yeni depolar eklendi: ${CYAN}chaotic-aur, arcolinux_repo, arcolinux_repo_3party, arcolinux_repo_xlarge${NC}"
    echo -e "2. ParallelDownloads = 5 ayarı eklendi"
    echo -e "3. ILoveCandy ve Color ayarları aktifleştirildi"
  else
    echo -e "${RED}pacman.conf güncellenirken hata oluştu${NC}"
    echo "[FAILED] pacman.conf güncelleme hatası - $(date)" >>$LOG_FILE
    return 1
  fi
}

# Log dosyası oluştur
LOG_FILE="package_installation.log"
touch $LOG_FILE

# pacman.conf güncelleme
update_pacman_conf
if [ $? -ne 0 ]; then
  echo -e "${RED}pacman.conf güncellenemedi. Script sonlandırılıyor.${NC}"
  exit 1
fi

# Paket kurulumuna başlamadan önce onay al
if ! get_confirmation "Paket kurulumuna başlamak istiyor musunuz?"; then
  echo -e "${RED}Paket kurulumu iptal edildi${NC}"
  exit 0
fi

# Paket yöneticisini belirle
if command -v paru >/dev/null 2>&1; then
  PKG_MANAGER="paru"
  echo -e "${BLUE}Paru bulundu, AUR desteği ile kurulum yapılacak${NC}"
else
  PKG_MANAGER="sudo pacman"
  echo -e "${YELLOW}Paru bulunamadı, Pacman kullanılacak${NC}"
fi

echo "Kurulum başlangıç zamanı: $(date)" >>$LOG_FILE
echo "Kullanılan paket yöneticisi: $PKG_MANAGER" >>$LOG_FILE

# Başarılı, atlanan ve başarısız paketleri takip etmek için diziler
declare -a successful_packages
declare -a skipped_packages
declare -a failed_packages

# Paketin kurulu olup olmadığını kontrol et
check_package_installed() {
  local package=$1
  if pacman -Qi "$package" >/dev/null 2>&1; then
    return 0 # Paket kurulu
  elif [ "$PKG_MANAGER" = "paru" ] && paru -Qi "$package" >/dev/null 2>&1; then
    return 0 # AUR paketi kurulu
  else
    return 1 # Paket kurulu değil
  fi
}

# Paketi kurma fonksiyonu
install_package() {
  local package=$1
  # Önce paketin kurulu olup olmadığını kontrol et
  if check_package_installed "$package"; then
    echo -e "${CYAN}~ $package zaten kurulu, atlanıyor${NC}"
    skipped_packages+=("$package")
    echo "[SKIPPED] $package - already installed - $(date)" >>$LOG_FILE
    return 2
  fi

  echo -e "${BLUE}Kuruluyor: $package${NC}"
  if [ "$PKG_MANAGER" = "paru" ]; then
    if paru -S --needed --noconfirm "$package"; then
      return 0
    elif sudo pacman -S --needed --noconfirm "$package"; then
      return 0
    else
      return 1
    fi
  else
    if sudo pacman -S --needed --noconfirm "$package"; then
      return 0
    else
      return 1
    fi
  fi
}

# all_packages.txt dosyasından paketleri oku ve kur
total_packages=0
while IFS= read -r package || [[ -n "$package" ]]; do
  # Yorumları ve boş satırları atla
  [[ $package =~ ^#.*$ ]] && continue
  [[ -z "${package// /}" ]] && continue

  ((total_packages++))
  install_package "$package"
  case $? in
  0) # Başarılı kurulum
    echo -e "${GREEN}✓ $package başarıyla kuruldu${NC}"
    successful_packages+=("$package")
    echo "[SUCCESS] $package - $(date)" >>$LOG_FILE
    ;;
  1) # Kurulum hatası
    echo -e "${RED}✗ $package kurulumunda hata${NC}"
    failed_packages+=("$package")
    echo "[FAILED] $package - $(date)" >>$LOG_FILE
    ;;
  2) # Zaten kurulu
    # Log zaten check_package_installed içinde yapıldı
    ;;
  esac
done <"all_packages.txt"

# Özet raporu
echo -e "\n${BLUE}=== Kurulum Özeti ===${NC}"
echo -e "Toplam paket sayısı: ${BLUE}$total_packages${NC}"
echo -e "Başarılı kurulumlar: ${GREEN}${#successful_packages[@]}${NC}"
echo -e "Atlanan (zaten kurulu): ${CYAN}${#skipped_packages[@]}${NC}"
echo -e "Başarısız kurulumlar: ${RED}${#failed_packages[@]}${NC}"

if [ ${#successful_packages[@]} -gt 0 ]; then
  echo -e "\nBaşarıyla kurulan paketler:"
  printf "${GREEN}%s${NC}\n" "${successful_packages[@]}"
fi

if [ ${#skipped_packages[@]} -gt 0 ]; then
  echo -e "\nZaten kurulu olan paketler:"
  printf "${CYAN}%s${NC}\n" "${skipped_packages[@]}"
fi

if [ ${#failed_packages[@]} -gt 0 ]; then
  echo -e "\nKurulamayan paketler:"
  printf "${RED}%s${NC}\n" "${failed_packages[@]}"
fi

echo -e "\nDetaylı log dosyası: $LOG_FILE"
