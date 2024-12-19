# =============================================================================
# ZSH Configuration File / ZSH Yapılandırma Dosyası
#
# Version: 1.0.1
# Author: Kenan Pelit
# Repository: github.com/kenanpelit/dotfiles
#
# Last Updated / Son Güncelleme: 2024
# =============================================================================

# System Variables / Sistem Değişkenleri
# -----------------------------------------------------------------------------
export EDITOR='vim'                      # Default text editor / Varsayılan metin düzenleyici
export VISUAL='vim'                      # Visual editor / Görsel düzenleyici
export PAGER='most'                      # Pager for manual pages / Manual sayfaları için sayfalayıcı
export TERM=xterm-256color               # Terminal type / Terminal tipi
export HISTCONTROL=ignoreboth:erasedups  # History control / Geçmiş kontrolü

# XDG Base Directory Specification / XDG Temel Dizin Tanımlamaları
# -----------------------------------------------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"         # Config directory / Ayar dizini
export XDG_CACHE_HOME="$HOME/.cache"           # Cache directory / Önbellek dizini
export XDG_DATA_HOME="$HOME/.local/share"      # Data directory / Veri dizini

# Create Required Directories (Uncomment if needed) / Gerekli Dizinleri Oluştur (Gerekirse yorumu kaldırın)
# -----------------------------------------------------------------------------
#mkdir -p "$XDG_CONFIG_HOME"/{zsh,zsh/completions} "$XDG_CACHE_HOME/zsh"

# History Settings / Geçmiş Ayarları
# -----------------------------------------------------------------------------
HISTFILE="$XDG_CONFIG_HOME/zsh/history"  # History file location / Geçmiş dosyası konumu
HISTSIZE=10000                           # History size in memory / Bellekteki geçmiş boyutu
SAVEHIST=10000                           # History size on disk / Diskteki geçmiş boyutu

# History Options / Geçmiş Seçenekleri
setopt HIST_IGNORE_ALL_DUPS              # No duplicate commands / Tekrar eden komutları yoksay
setopt EXTENDED_HISTORY                  # Save timestamp / Zaman damgası kaydet
setopt HIST_VERIFY                       # Verify history expansion / Geçmiş genişletmesini doğrula
setopt HIST_IGNORE_SPACE                 # Ignore commands with leading space / Boşlukla başlayan komutları yoksay

# Ignore Patterns / Yoksayma Desenleri
export HISTORY_IGNORE="(ls|pwd|cd|pirate-get|tsm|exit|clear|history)*"

# Completion Settings / Tamamlama Ayarları
# -----------------------------------------------------------------------------
zstyle ':completion:*' accept-exact '*(N)'     # Speed up completion / Tamamlamayı hızlandır
zstyle ':completion:*' accept-exact-dirs true  # Directory completion / Dizin tamamlama
zstyle ':completion:*' use-cache on            # Enable cache / Önbelleği etkinleştir
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"
zstyle ':completion:*:*:*:*:*' menu select    # Interactive menu / Etkileşimli menü
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive / Büyük-küçük harf duyarsız
zstyle ':completion:*' special-dirs true       # Special directories / Özel dizinler

# FZF Configuration / FZF Yapılandırması
# -----------------------------------------------------------------------------
# Base Settings / Temel Ayarlar
export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --border --cycle --marker='✓' --pointer='▶'"

# Preview Settings / Önizleme Ayarları
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}' \
                       --preview-window 'right:60%:wrap'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# Search Commands / Arama Komutları
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .cache'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude .cache"

# Load FZF Integration / FZF Entegrasyonunu Yükle
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Path Configuration / Yol Yapılandırması
# -----------------------------------------------------------------------------
typeset -U path  # Unique paths only / Tekrar eden yolları engelle
path=(
    "$HOME/.bin"
    "$HOME/.local/bin"
    "/usr/local/bin"
    "$HOME/.cargo/bin"
    $path
)

# Oh-My-Zsh Configuration / Oh-My-Zsh Yapılandırması
# -----------------------------------------------------------------------------
zstyle ':omz:update' mode disabled  # Disable auto-update / Otomatik güncellemeyi devre dışı bırak
export ZSH="$HOME/.config/oh-my-zsh"

# Oh-My-Zsh Installation Check (Uncomment if needed) / Oh-My-Zsh Kurulum Kontrolü (Gerekirse yorumu kaldırın)
#if [[ ! -d "$ZSH" ]]; then
#    echo "Oh-My-Zsh kurulu değil. Kurulum yapılıyor..."
#    # Installation command / Kurulum komutu
#fi

# Plugins / Eklentiler
plugins=(
    git                      # Git integration / Git entegrasyonu
    sudo                     # ESC twice for sudo / İki kez ESC ile sudo
    command-not-found        # Suggest packages / Paket önerileri
    history                  # History shortcuts / Geçmiş kısayolları
    copypath                 # Copy current path / Mevcut yolu kopyala
    aliases                  # Alias management / Alias yönetimi
    dirhistory               # Directory navigation / Dizin gezinme
    colored-man-pages        # Colored man pages / Renkli man sayfaları
    ssh-agent                # SSH agent / SSH aracısı
    fzf                      # Fuzzy finder / Bulanık arama
    docker                   # Docker commands / Docker komutları
    docker-compose           # Docker-compose / Docker-compose
    z                        # Directory jumping / Dizin atlama
    zsh-autosuggestions      # Command suggestions / Komut önerileri
    zsh-syntax-highlighting  # Syntax highlighting / Sözdizimi vurgulama
)

source $ZSH/oh-my-zsh.sh

# ZSH Settings / ZSH Ayarları
# -----------------------------------------------------------------------------
setopt GLOB_DOTS         # Show hidden files / Gizli dosyaları göster
unsetopt SHARE_HISTORY   # Don't share history / Geçmişi paylaşma
autoload -Uz compinit    # Initialize completion / Tamamlamayı başlat

# Completion Directories / Tamamlama Dizinleri
fpath=("$XDG_CONFIG_HOME/zsh/completions" $fpath)

# Optimize Completion / Tamamlama Optimizasyonu
if [[ -n ${XDG_CACHE_HOME}/zsh/.zcompdump(#qN.mh+24) ]]; then
    compinit -d "${XDG_CACHE_HOME}/zsh/.zcompdump"
else
    compinit -C -d "${XDG_CACHE_HOME}/zsh/.zcompdump"
fi

# Load Additional Configurations / Ek Yapılandırmaları Yükle
# -----------------------------------------------------------------------------
# SSH Completion / SSH Tamamlama
[[ -f "$XDG_CONFIG_HOME/zsh/completions/_assh" ]] && source "$XDG_CONFIG_HOME/zsh/completions/_assh"

# Colors / Renkler
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b)"

# Personal Settings / Kişisel Ayarlar
[[ -f "$XDG_CONFIG_HOME/zsh/aliases.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/aliases.zsh"
[[ -f "$XDG_CONFIG_HOME/zsh/functions.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/functions.zsh"

# SSH Cache Management / SSH Önbellek Yönetimi
# -----------------------------------------------------------------------------
if [[ ! -f "$XDG_CACHE_HOME/assh/hosts" ]] || find "$XDG_CACHE_HOME/assh/hosts" -mtime +1 -print0 | grep -q .; then
    assh-manager.sh -u >/dev/null 2>&1
fi

# Terminal Settings / Terminal Ayarları
# -----------------------------------------------------------------------------
unset zle_bracketed_paste  # Disable bracketed paste / Parantezli yapıştırmayı devre dışı bırak

# Key Bindings / Tuş Atamaları
bindkey "^[[1~" beginning-of-line  # Home key / Home tuşu
bindkey "^[[4~" end-of-line        # End key / End tuşu

# Path Cleanup / Yol Temizleme
path=("${path[@]:#*/nonexistent/*}")  # Remove nonexistent paths / Var olmayan yolları kaldır

# Prompt Configuration / Prompt Yapılandırması
# -----------------------------------------------------------------------------
eval "$(starship init zsh)"  # Initialize Starship prompt / Starship prompt'unu başlat
