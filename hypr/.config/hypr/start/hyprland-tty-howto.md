# How to Start Hyprland from TTY

The Hyprland service didn't work out for me due to some permission issues, so I needed to use a different approach. Thanks for the idea though.

This guide explains how to start Hyprland directly from TTY without using a display manager (like GDM, SDDM).

## Prerequisites
- Arch Linux (or other Linux distribution)
- Hyprland installed
- Basic knowledge of terminal usage

## Setup Steps

1. First, create or edit your shell profile file (`~/.bash_profile` for bash or `~/.zprofile` for zsh):
```bash
vim ~/.bash_profile  # or ~/.zprofile
```

2. Add the following lines to check if we're on TTY1 and Wayland isn't running:
```bash
if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec hyprflow
fi
```

3. Make the script executable and create a symlink:
```bash
# Create symlink in /usr/local/bin
sudo ln -sf ~/.config/hypr/start/hyprland_tty.sh /usr/local/bin/hyprflow
```

## Optional Security Check
Add this at the beginning of your `hyprland.sh` script to ensure it only runs on TTY1:
```bash
if [ "$(tty)" != "/dev/tty1" ]; then
    echo "This script can only be run on tty1"
    exit 1
fi
```

## Usage
1. Reboot your system
2. At the TTY1 login prompt, enter your username and password
3. Hyprland should start automatically

## Troubleshooting
- If Hyprland doesn't start, you can:
  - Switch to TTY2 with `Ctrl+Alt+F2`
  - Switch to TTY3 with `Ctrl+Alt+F3`
  - Switch to TTY4 with `Ctrl+Alt+F4`
  - Return to TTY1 (where Hyprland should be) with `Ctrl+Alt+F1`
  
This way you can debug while keeping your main TTY1 session intact. If you need to kill Hyprland, you can do so from another TTY.
- Check the logs: `journalctl -b -t Hyprland`
- Make sure all environment variables in your hyprland.sh are correctly set

---

# TTY'den Hyprland Başlatma Rehberi

Bu rehber, bir görüntü yöneticisi (GDM, SDDM gibi) kullanmadan Hyprland'i doğrudan TTY'den başlatmayı açıklar.

## Ön Koşullar
- Arch Linux (veya başka bir Linux dağıtımı)
- Hyprland kurulu olmalı
- Temel terminal kullanım bilgisi

## Kurulum Adımları

1. İlk olarak, shell profil dosyanızı oluşturun veya düzenleyin (`bash` için `~/.bash_profile` veya `zsh` için `~/.zprofile`):
```bash
vim ~/.bash_profile  # veya ~/.zprofile
```

2. TTY1'de olduğumuzu ve Wayland'in çalışmadığını kontrol etmek için aşağıdaki satırları ekleyin:
```bash
if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec hyprflow
fi
```

3. Sembolik link oluşturun:
```bash
# /usr/local/bin altında sembolik link oluştur
sudo ln -sf ~/.config/hypr/start/hyprland_tty.sh /usr/local/bin/hyprflow
```

## Opsiyonel Güvenlik Kontrolü
`hyprland.sh` scriptinizin başına, sadece TTY1'de çalışmasını sağlamak için şunu ekleyin:
```bash
if [ "$(tty)" != "/dev/tty1" ]; then
    echo "Bu script sadece tty1'de çalıştırılabilir"
    exit 1
fi
```

## Kullanım
1. Sisteminizi yeniden başlatın
2. TTY1 giriş ekranında kullanıcı adı ve şifrenizi girin
3. Hyprland otomatik olarak başlamalı

## Sorun Giderme
- Eğer Hyprland başlamazsa, şunları yapabilirsiniz:
  - TTY2'ye geçmek için `Ctrl+Alt+F2`
  - TTY3'e geçmek için `Ctrl+Alt+F3`
  - TTY4'e geçmek için `Ctrl+Alt+F4`
  - Hyprland'in çalışması gereken TTY1'e dönmek için `Ctrl+Alt+F1`
  
Bu şekilde ana TTY1 oturumunuzu bozmadan debug yapabilirsiniz. Eğer Hyprland'i sonlandırmanız gerekirse, bunu başka bir TTY'den yapabilirsiniz.
- Logları kontrol edin: `journalctl -b -t Hyprland`
- hyprland.sh dosyanızdaki tüm ortam değişkenlerinin doğru ayarlandığından emin olun
