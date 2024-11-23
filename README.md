# Dotfiles

Bu repo, Linux sistemim için yapılandırma dosyalarımı (dotfiles) içerir. GNU Stow kullanılarak yönetilmektedir.

## 📁 Mevcut Yapılandırmalar

- `alacritty/` - Alacritty terminal emülatörü yapılandırması
- `bin/` - Kişisel script ve yardımcı programlar
- `fish/` - Fish shell yapılandırması
- `hypr/` - Hyprland pencere yöneticisi yapılandırması
- `kitty/` - Kitty terminal emülatörü yapılandırması
- `mpv/` - MPV medya oynatıcı yapılandırması
- `nvim/` - Neovim editör yapılandırması
- `ranger/` - Ranger dosya yöneticisi yapılandırması
- `rofi/` - Rofi uygulama başlatıcı yapılandırması
- `sesh/` - Sesh oturum yöneticisi yapılandırması
- `tmux/` - Tmux terminal multiplexer yapılandırması
- `zsh/` - Zsh shell yapılandırması

## 🚀 Hızlı Başlangıç

### Ön Gereksinimler

```bash
# Arch Linux için
sudo pacman -S git stow

# Debian/Ubuntu için
sudo apt update
sudo apt install git stow
```

### Kurulum

1. Repoyu klonlayın:
```bash
git clone git@github.com:kullanıcıadınız/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Make kullanarak kurulum yapın:
```bash
make install  # Tüm yapılandırmaları kurar
```

Ya da tek bir programın yapılandırmasını kurmak için:
```bash
stow nvim  # Sadece neovim yapılandırmasını kurar
```

## 🔧 Yönetim

### Yapılandırma Kaldırma
```bash
stow -D nvim  # nvim yapılandırmasını kaldırır
# veya
make uninstall  # Tüm yapılandırmaları kaldırır
```

### Güncelleme
```bash
cd ~/.dotfiles
git pull
make reinstall  # Tüm yapılandırmaları yeniden yükler
```

## 📝 Yeni Yapılandırma Ekleme

Yeni bir program için yapılandırma eklemek:

1. Yeni dizin oluşturun:
```bash
mkdir yeni_program
```

2. Yapılandırma dosyalarını doğru yol yapısıyla yerleştirin:
```bash
yeni_program/
└── .config/
    └── yeni_program/
        └── config
```

3. Stow ile bağlayın:
```bash
stow yeni_program
```

## 🔄 Gelecek Güncellemeler

Bu repo aktif olarak güncellenmektedir. Gelecekte eklenecek yapılandırmalar:
- [ ] Waybar
- [ ] Mako
- [ ] Swaylock
- [ ] Dunst
- [ ] ... (diğer eklemek istediğiniz programlar)

## ⚙️ Makefile Komutları

```bash
make install    # Tüm yapılandırmaları kurar
make uninstall  # Tüm yapılandırmaları kaldırır
make reinstall  # Tüm yapılandırmaları yeniden yükler
```

## 📜 Lisans

Bu repo MIT lisansı altında dağıtılmaktadır.
