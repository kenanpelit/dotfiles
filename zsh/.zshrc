# Temel sistem değişkenleri
export EDITOR='vim'
export VISUAL='vim'
export PAGER='most'
export TERM=xterm-256color
export HISTCONTROL=ignoreboth:erasedups

# XDG Base Directory tanımlamaları
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# Gerekli dizinleri oluştur
mkdir -p "$XDG_CONFIG_HOME/zsh"

# Geçmiş ayarları
HISTFILE="$XDG_CONFIG_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY
setopt HIST_VERIFY

# Performans ayarları ve completion
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' special-dirs true
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$XDG_CACHE_HOME/zsh"

# FZF ayarları
export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --border"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"

# FZF key bindings ve completion
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

# Alternatif lokasyonlar için kontrol
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Path tanımlamaları
typeset -U path  # Unique paths only
path=(
   "$HOME/.bin"
   "$HOME/.local/bin"
   "/usr/local/bin"
   "$HOME/.cargo/bin"
   $path
)

# Oh-My-Zsh
zstyle ':omz:update' mode disabled
export ZSH="$HOME/.config/oh-my-zsh"

plugins=(
   git 
   sudo 
   command-not-found 
   history 
   copypath 
   aliases
   dirhistory 
   colored-man-pages 
   ssh-agent 
   fzf 
   docker 
   docker-compose
   z
   zsh-autosuggestions 
   zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ZSH ayarları ve completion
setopt GLOB_DOTS
unsetopt SHARE_HISTORY
autoload -Uz compinit

# Completion paths
fpath=("$XDG_CONFIG_HOME/zsh/completions" $fpath)

# Completion optimizasyonu - günde bir kez yenile
if [[ -n ${XDG_CACHE_HOME}/zsh/.zcompdump(#qN.mh+24) ]]; then
   compinit -d "${XDG_CACHE_HOME}/zsh/.zcompdump"
else
   compinit -C -d "${XDG_CACHE_HOME}/zsh/.zcompdump"
fi

# SSH completion için özel yükleme
[[ -f "$XDG_CONFIG_HOME/zsh/completions/_assh" ]] && source "$XDG_CONFIG_HOME/zsh/completions/_assh"

# Renk ve syntax desteği
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b)"

# Kişisel ayarlar ve aliases
[[ -f "$XDG_CONFIG_HOME/zsh/aliases.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/aliases.zsh"
[[ -f "$XDG_CONFIG_HOME/zsh/functions.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/functions.zsh"

# SSH hosts cache kontrolü (günlük güncelleme)
if [[ ! -f "$XDG_CACHE_HOME/assh/hosts" ]] || find "$XDG_CACHE_HOME/assh/hosts" -mtime +1 -print0 | grep -q .; then
    assh-manager.sh -u >/dev/null 2>&1
fi

# Disable bracketed paste
unset zle_bracketed_paste

# Tuş tanımlamaları
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

# Prompt (en son yüklenmeli)
eval "$(starship init zsh)"
