#!/usr/bin/env bash
# ~/.config/hypr/hyprland.sh dosyasının başına ekleyin
if [ "$(tty)" != "/dev/tty1" ]; then
  echo "Bu script sadece tty1'de çalıştırılabilir"
  exit 1
fi
# =================================================================
# Hyprland Wayland Yapılandırması
# =================================================================
# -----------------------------
# Oturum ve Masaüstü Ayarları
# -----------------------------
export XDG_CURRENT_DESKTOP=Hyprland # Mevcut masaüstü ortamını Hyprland olarak tanımlar
export XDG_SESSION_TYPE=wayland     # Oturum tipini Wayland olarak belirler
export XDG_SESSION_DESKTOP=Hyprland # Masaüstü oturumunu Hyprland olarak ayarlar

# XDG Runtime Directory tanımlaması
: "${XDG_RUNTIME_DIR:=/run/user/${UID}}"
export XDG_RUNTIME_DIR

# -----------------------------
# Wayland ve WLRoots Ayarları
# -----------------------------
export HYPRLAND_LOG_WLR=1 # WLRoots log kayıtlarını etkinleştirir

# -----------------------------
# Firefox Yapılandırması
# -----------------------------
export MOZ_ENABLE_WAYLAND=1        # Firefox'ta Wayland desteğini etkinleştirir
export MOZ_WEBRENDER=1             # WebRender grafik motorunu etkinleştirir
export MOZ_USE_XINPUT2=1           # Gelişmiş input yönetimini etkinleştirir
export MOZ_CRASHREPORTER_DISABLE=1 # Çökme raporlayıcıyı devre dışı bırakır

# -----------------------------
# Grafik ve OpenGL Ayarları
# -----------------------------
export CLUTTER_BACKEND=wayland # Clutter kütüphanesi için Wayland backend'ini kullanır
export OZONE_PLATFORM=wayland  # Chromium tabanlı uygulamalar için Wayland desteğini etkinleştirir

# -----------------------------
# Uygulama Uyumluluk Ayarları
# -----------------------------
export SDL_VIDEODRIVER=wayland # SDL uygulamaları için Wayland sürücüsünü kullanır

# -----------------------------
# QT Uygulamaları Ayarları
# -----------------------------
export QT_QPA_PLATFORM="wayland;xcb"         # QT uygulamaları için önce Wayland, sonra XCB kullanır
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1 # QT pencere dekorasyonlarını devre dışı bırakır
export QT_QPA_PLATFORMTHEME=gtk3             # QT uygulamaları için GTK3 temasını kullanır
export QT_AUTO_SCREEN_SCALE_FACTOR=1         # Otomatik ekran ölçeklendirmesini etkinleştirir
export QT_STYLE_OVERRIDE=kvantum             # QT stil teması olarak Kvantum'u kullanır

# -----------------------------
# GTK Ayarları
# -----------------------------
export GDK_BACKEND=wayland # GTK uygulamaları için Wayland backend'ini kullanır
export GDK_SCALE=1         # GTK uygulamaları için ölçekleme faktörünü ayarlar

# Font rendering
export FREETYPE_PROPERTIES="truetype:interpreter-version=40" # Font renderlamayı iyileştirir

# -----------------------------
# DBus ve Systemd Entegrasyonu
# -----------------------------
# Sistem servislerine masaüstü ortam değişkenlerini aktarır
systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP &

# DBus ortam değişkenlerini günceller
dbus-update-activation-environment --systemd XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE XDG_SESSION_TYPE XDG_SESSION_DESKTOP &

# Hyprland'ı systemd log kaydı ile başlatır
exec systemd-cat --identifier=Hyprland /usr/bin/Hyprland $@
