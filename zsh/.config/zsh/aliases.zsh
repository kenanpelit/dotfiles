# Environment
export EDITOR=vim
export VISUAL=vim
export BROWSER=zen-browser
export PASSWORD_STORE_CLIP_TIME=15
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_CLIP_PROGRAM="$HOME/.bin/pass-clip-both.sh"

# Shell Config Aliases
alias cfg-fa="$EDITOR ~/.config/fish/alias.fish"
alias cfg-fc="$EDITOR ~/.config/fish/config.fish"
alias cfg-zshrc="$EDITOR ~/.zshrc"
alias cfg-zsh-aliases="$EDITOR ~/.config/zsh/aliases.zsh"
alias cfg-zsh-function="$EDITOR ~/.config/zsh/functions.zsh"

# System Config Aliases (with sudo)
alias cfgs-fstab="sudo $EDITOR /etc/fstab"
alias cfgs-grub="sudo $EDITOR /etc/default/grub"
alias cfgs-confgrub="sudo $EDITOR /boot/grub/grub.cfg"
alias cfgs-hostname="sudo $EDITOR /etc/hostname"
alias cfgs-hosts="sudo $EDITOR /etc/hosts"
alias cfgs-lightdm="sudo $EDITOR /etc/lightdm/lightdm.conf"
alias cfgs-mkinitcpio="sudo $EDITOR /etc/mkinitcpio.conf"
alias cfgs-nsswitch="sudo $EDITOR /etc/nsswitch.conf"
alias cfgs-sddm="sudo $EDITOR /etc/sddm.conf"
alias cfgs-sddmk="sudo $EDITOR /etc/sddm.conf.d/kde_settings.conf"
alias cfgs-pacman="sudo $EDITOR /etc/pacman.conf"
alias cfgs-mirrorlist="sudo $EDITOR /etc/pacman.d/mirrorlist"
alias cfgs-arcomirrorlist="sudo $EDITOR /etc/pacman.d/arcolinux-mirrorlist"
alias cfgs-gnupgconf="sudo $EDITOR /etc/pacman.d/gnupg/gpg.conf"
alias cfgs-samba="sudo $EDITOR /etc/samba/smb.conf"
alias cfgs-resolv="sudo $EDITOR /etc/resolv.conf"
alias cfgs-plymouth="sudo $EDITOR /etc/plymouth/plymouthd.conf"
alias cfgs-vconsole="sudo $EDITOR /etc/vconsole.conf"
alias cfgs-environment="sudo $EDITOR /etc/environment"
alias cfgs-loader="sudo $EDITOR /boot/efi/loader/loader.conf"

# Application Config Aliases
alias cfg-alacritty="$EDITOR ~/.config/alacritty/alacritty.yml"
alias cfg-assh="$EDITOR ~/.ssh/assh.yml"
alias cfg-key="$EDITOR ~/.bin/gnome-shell-config.sh"
alias cfg-mpv="$EDITOR ~/.config/mpv/mpv.conf"
alias cfg-mpv-input="$EDITOR ~/.config/mpv/input.conf"
alias cfg-neofetch="$EDITOR ~/.config/neofetch/config.conf"
alias cfg-ranger="$EDITOR ~/.config/ranger/rc.conf"
alias cfg-ranger-rifle="$EDITOR ~/.config/ranger/rifle.conf"
alias cfg-ranger-commands="$EDITOR ~/.config/ranger/commands.py"
alias cfg-set="$EDITOR ~/.bin/___kenp_settings.sh"
alias cfg-sesh="$EDITOR ~/.config/sesh/sesh.toml"
alias cfg-snippetrc="$EDITOR ~/.config/notekami/snippetline/snippetrc"
alias cfg-tmuxrc="$EDITOR ~/.config/tmux/tmux.conf"
alias cfg-tmuxrc-local="$EDITOR ~/.config/tmux/tmux.conf.local"
alias cfg-touchegg="$EDITOR ~/.config/touchegg/touchegg.conf"
alias cfg-urlview="$EDITOR ~/.urlview"

# Hyprland & Waybar Config
alias cfg-hypr-conf="$EDITOR ~/.config/hypr/hyprland.conf"
alias cfg-hypr-00_env="$EDITOR ~/.config/hypr/config/00_env.conf"
alias cfg-hypr-01_shift="$EDITOR ~/.config/hypr/config/01_shift.conf"
alias cfg-hypr-02_monitor="$EDITOR ~/.config/hypr/config/02_monitor.conf"
alias cfg-hypr-03_defaults="$EDITOR ~/.config/hypr/config/03_defaults.conf"
alias cfg-hypr-04_themes="$EDITOR ~/.config/hypr/config/04_themes.conf"
alias cfg-hypr-05_winrules="$EDITOR ~/.config/hypr/config/05_winrules.conf"
alias cfg-hypr-06_keybinds="$EDITOR ~/.config/hypr/config/06_keybinds.conf"
alias cfg-hypr-07_plugins="$EDITOR ~/.config/hypr/config/07_plugins.conf"
alias cfg-hypr-08_autostart="$EDITOR ~/.config/hypr/config/08_autostart.conf"
alias cfg-waybar-conf="$EDITOR ~/.config/waybar/config.jsonc"
alias cfg-waybar-style="$EDITOR ~/.config/waybar/style.css"
alias cfg-start-zen-all="$EDITOR ~/.bin/hypr-start-zen-all.sh"
alias cfg-start-zen-sem-all="$EDITOR ~/.bin/hypr-start-zen-sem-all.sh"

# Package Management
alias sps='sudo pacman -S'
alias spr='sudo pacman -R'
alias sprs='sudo pacman -Rs'
alias sprdd='sudo pacman -Rdd'
alias spqo='sudo pacman -Qo'
alias spsii='sudo pacman -Sii'
alias pacman="sudo pacman --color auto"
alias update='sudo pacman -Syyu'
alias upall="paru -Syu --noconfirm"
alias paruskip="paru -S --mflags --skipinteg"
alias yayskip="yay -S --mflags --skipinteg"
alias trizenskip="trizen -S --skipinteg"
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias rmpkg="sudo pacman -Rdd"
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'
alias pacmanfix="sudo rm /var/lib/pacman/db.lck"
alias pamac-unlock="sudo rm /var/tmp/pamac/dbs/db.lock"

# Mirror Management
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 30 --number 10 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 30 --number 10 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 30 --number 10 --sort age --save /etc/pacman.d/mirrorlist"
alias mirrorx="sudo reflector --age 6 --latest 20 --fastest 20 --threads 5 --sort rate --protocol https --save /etc/pacman.d/mirrorlist"
alias mirrorxx="sudo reflector --age 6 --latest 20 --fastest 20 --threads 20 --sort rate --protocol https --save /etc/pacman.d/mirrorlist"
alias ram='rate-mirrors --allow-root --disable-comments arch | sudo tee /etc/pacman.d/mirrorlist'
alias rams='rate-mirrors --allow-root --disable-comments --protocol https arch | sudo tee /etc/pacman.d/mirrorlist'

# Directory & File Operations
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -alFh'
alias l='ls'
alias l.="ls -A | egrep '^\.'"
alias listdir="ls -d */ > list"
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias tarnow='tar -acf'
alias untar='tar -xvf'
alias wget="wget -c"

# System Information
alias df="df -h"
alias ip="ip -color"
alias free="free -mt"
alias hw="hwinfo --short"
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias jctl="journalctl -p 3 -xb"
alias microcode="grep . /sys/devices/system/cpu/vulnerabilities/*"
alias cpu="cpuid -i | grep uarch | head -n 1"
alias sysfailed="systemctl list-units --failed"
alias userlist="cut -d: -f1 /etc/passwd | sort"

# System Maintenance
alias fix-permissions="sudo chown -R $USER:$USER ~/.config ~/.local"
alias fix-keys="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias fix-pacman-conf="/usr/local/bin/arcolinux-fix-pacman-conf"
alias fix-pacman-keyserver="/usr/local/bin/arcolinux-fix-pacman-gpg-conf"
alias fix-sddm-config="/usr/bin/fix-sddm-config"
alias fix-keyserver="[ -d ~/.gnupg ] || mkdir ~/.gnupg ; cp /etc/pacman.d/gnupg/gpg.conf ~/.gnupg/ ; echo 'done'"

# Git Operations
alias rmgitcache="rm -r ~/.cache/git"
alias grh="git reset --hard"
alias undopush="git push -f origin HEAD^:master"

# Desktop Environment & Theme
alias xd="ls /usr/share/xsessions"
alias xdw="ls /usr/share/wayland-sessions"
alias copywall="variety -f"
alias fzfcopy="greenclip print | grep . | fzf -e | xargs -r -d'\n' -I '{}' greenclip print '{}'"
alias archset="gsettings set org.gnome.desktop.background picture-uri-dark 'file:///home/kenan/.wall/arch.png'"
alias conkyb="conky -c ~/.config/conky/breaking-bad/AURO-breaking-bad-LUA.conkyrc & sleep 1s"

# System Tools
alias clean='clear; seq 1 $(tput cols) | sort -R | sparklines | lolcat'
alias rg="rg --sort path"
alias update-fc="sudo fc-cache -fv"
alias merge="xrdb -merge ~/.Xresources"
alias kk="/usr/bin/yazi"
alias k="/usr/bin/ranger"
alias probe="sudo -E hw-probe -all -upload"
alias ssp="sudo systemctl poweroff -i"
alias ssr="sudo systemctl reboot -i"

# BTRFS & Snapper
alias btrfsfs="sudo btrfs filesystem df /"
alias btrfsli="sudo btrfs su li / -t"
alias snapcroot="sudo snapper -c root create-config /"
alias snapchome="sudo snapper -c home create-config /home"
alias snapli="sudo snapper list"
alias snapli-all="sudo snapper list --all"
alias snapcr="sudo snapper -c root create"
alias snapch="sudo snapper -c home create"

# Media & Download
alias ytdl="yt-dlp"
alias yta-aac="yt-dlp --extract-audio --audio-format aac"
alias yta-best="yt-dlp --extract-audio --audio-format best"
alias yta-flac="yt-dlp --extract-audio --audio-format flac"
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3"
alias ytv-best="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4"
alias y="ytdl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4"
alias record='gpu-screen-recorder -w HDMI-0 -f 60 -o ~/Videos/recording-$(date +"%Y-%m-%d-%H-%M-%S").mp4 -a default_input -q ultra -ac aac'
alias wsimplescreenrecorder="wf-recorder -a"

# Package List & Info
alias list="sudo pacman -Qqe"
alias listt="sudo pacman -Qqet"
alias listaur="sudo pacman -Qqem"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"
alias big="expac -H M '%m\t%n' | sort -h | nl"

# Grub Management
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias grub-install-efi="sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi"

# Display Manager Switching
alias tolightdm="sudo pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm --needed ; sudo systemctl enable lightdm.service -f ; echo 'Lightm is active - reboot now'"
alias tosddm="sudo pacman -S sddm --noconfirm --needed ; sudo systemctl enable sddm.service -f ; echo 'Sddm is active - reboot now'"
alias togdm="sudo pacman -S gdm --noconfirm --needed ; sudo systemctl enable gdm.service -f ; echo 'Gdm is active - reboot now'"

# Shell Switching
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Done. Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Done. Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Done. Now log out.'"

# Log Management
alias lcalamares="bat /var/log/Calamares.log"
alias lpacman="bat /var/log/pacman.log"
alias lxorg="bat /var/log/Xorg.0.log"
alias lxorgo="bat /var/log/Xorg.0.log.old"

# Backup & Sync
alias home2rsync2hay="rsync -avzhr --info=progress2 --stats --del --exclude-from .rsync-exclude-backup /home/kenan /hay/home/"
alias home2rsync2kenp="rsync -avzhr --info=progress2 --stats --del --exclude-from .rsync-exclude-backup /home/kenan /kenp/home/"

# Leftwm Theme Management
alias lti="leftwm-theme install"
alias ltu="leftwm-theme uninstall"
alias lta="leftwm-theme apply"
alias ltupd="leftwm-theme update"
alias ltupg="leftwm-theme upgrade"

# Keyboard & Locale
alias give-me-qwerty-tr="sudo localectl set-x11-keymap tr"
alias give-me-qwerty-trf="sudo localectl set-x11-keymap trf"
alias setlocale="sudo localectl set-locale LANG=en_US.UTF-8"
alias setlocales="sudo localectl set-x11-keymap trf && sudo localectl set-locale LANG=en_US.UTF-8"

# Cryptocurrency
alias coin="cointop holdings -h --convert usd"
alias cot="cointop --only-table"
alias co="cointop --only-table -c ~/.config/cointop/configkenp.toml"

# Misc Utilities
alias audio="pactl info | grep 'Server Name'"
alias bls="betterlockscreen -u /usr/share/backgrounds/arcolinux/"
alias vbm="sudo /usr/local/bin/arcolinux-vbox-share"
alias unhblock="hblock -S none -D none"
alias subdown="OpenSubtitlesDownload --cli -l tur"
alias takeover="tmux detach -a"

# Transmission aliasları
alias tsm='~/.bin/tsm'
alias tsml='tsm list'
alias tsma='tsm add'
alias tsms='tsm speed'
alias tsmst='tsm start'
alias tsmp='tsm stop'
alias tsmr='tsm remove'
alias tsmi='tsm info'
alias tsmf='tsm files'
alias tsmpurge='tsm purge'
alias tsmsa='tsm start all'
alias tsmpa='tsm stop all'
alias tsmra='tsm remove all'

# Completion tanımlamaları
compdef _gnu_generic tsm

# Alias açıklamalarını tanımla
zstyle ':completion:*:*:tsm:*' list-colors '=(#b)(*)=0=94'
zstyle ':completion:*:aliases' list-colors '=*=94'

# Her komut için açıklamalar
compctl -K _tsm_commands tsm
function _tsm_commands() {
 local commands=(
 "tsm:Transmission yönetim aracı"
 "tsml:Torrent listesini göster"
 "tsma:Yeni torrent ekle"
 "tsms:İndirme/yükleme hızlarını göster"
 "tsmst:Torrent başlat"
 "tsmp:Torrent durdur"
 "tsmr:Torrent sil"
 "tsmi:Torrent detaylarını göster"
 "tsmf:Torrent dosyalarını listele"
 "tsmpurge:Torrent ve dosyalarını sil"
 "tsmsa:Tüm torrentleri başlat"
 "tsmpa:Tüm torrentleri durdur"
 "tsmra:Tüm torrentleri sil"
 )
 reply=("${(@f)$(printf "%s\n" "${commands[@]}")}")
}
