# Temel sistem değişkenleri
export EDITOR='vim'
export VISUAL='vim'
export PAGER='most'
export TERM=xterm-256color
export HISTCONTROL=ignoreboth:erasedups

# Geçmiş ayarları
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY
setopt HIST_VERIFY

# Performans ayarları
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# FZF ayarları
export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --border"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Path tanımlamaları
[[ -d "$HOME/.bin" ]] && PATH="$HOME/.bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"
[[ -d "/usr/local/bin" ]] && PATH="/usr/local/bin:$PATH"
[[ -d "$HOME/.cargo/bin" ]] && PATH="$HOME/.cargo/bin:$PATH"

# Oh-My-Zsh
export ZSH="/home/$USER/.oh-my-zsh"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting z sudo command-not-found history copypath dirhistory colored-man-pages aliases ssh-agent fzf docker docker-compose)
[[ -f $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh

# ZSH ayarları ve completion
setopt GLOB_DOTS
unsetopt SHARE_HISTORY
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
fpath=($HOME/.zsh/completion $fpath)

# Renk ve syntax desteği
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b)"
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Kişisel ayarlar ve aliases
[[ -f "$HOME/.config/zsh/aliases.zsh" ]] && source "$HOME/.config/zsh/aliases.zsh"
[[ -f "$HOME/.config/zsh/functions.zsh" ]] && source "$HOME/.config/zsh/functions.zsh"

# SSH ve cache
[[ ! -f ~/.cache/assh/hosts ]] && ~/.zsh/update-ssh-hosts.sh

# Disable bracketed paste
unset zle_bracketed_paste

# Home ve End tuşları için
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

# Prompt (en son yüklenmeli)
eval "$(starship init zsh)"

