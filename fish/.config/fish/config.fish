if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Aliases
if [ -f $HOME/.config/fish/alias.fish ]
    source $HOME/.config/fish/alias.fish
end

# find-the-command-git
if [ -f /usr/share/doc/find-the-command/ftc.fish ]
    source /usr/share/doc/find-the-command/ftc.fish
end

# find-the-autojump
if [ -f /usr/share/autojump/autojump.fish ]
    source /usr/share/autojump/autojump.fish
end

# reload fish config
function reload
    exec fish
    set -l config (status -f)
    echo "reloading: $config"
end

# User paths
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin $HOME/.local/bin $HOME/.cargo/bin $HOME/.config/hypr/scripts $HOME/.config/rofi $HOME/.config/tmux/bin $HOME/.config/hypr/wofi/scripts $HOME/.config/hypr/waybar/scripts $HOME/.local/share/gem/ruby/3.3.0/bin $fish_user_paths

# sets tools
set -gx EDITOR vim
set -gx VISUAL vim
#set -gx BROWSER brave
#set -gx BROWSER firefox
set -gx BROWSER zen-browser
#set -x TERM kitty
# Sets the terminal type for proper colors
set TERM xterm-256color

set GRIMBLAST_EDITOR swappy

# https://github.com/joshmedeski/t-smart-tmux-session-manager
set -Ux T_SESSION_NAME_INCLUDE_PARENT true
set -Ux FZF_TMUX_OPTS "-p 60%,80%"
set -Ux T_SESSION_USE_GIT_ROOT true

# Suppresses fish's intro message
#set fish_greeting
#function fish_greeting
#    fish_logo
#end

## commandline -r broken
#function fzf_prompt
#  set -l cmd (commandline)
#  echo
#  eval $cmd | command fzf | while read -l r; set result $result (string escape $r); end
#  if [ -n "$result" ]
#    echo "- cmd:" $cmd >> ~/.local/share/fish/fish_history
#    echo "  when:" (date "+%s") >> ~/.local/share/fish/fish_history
#    history merge
#    commandline -- (string join " " $result)
#  end
#  commandline -f repaint
#end

# transfer.sh upload script
function transfer --description 'Upload a file to transfer.sh'
    if [ $argv[1] ]
        # write to output to tmpfile because of progress bar
        set -l tmpfile ( mktemp -t transferXXX )
        curl --progress-bar --upload-file $argv[1] https://transfer.sh/(basename $argv[1]) >>$tmpfile
        echo >>$tmpfile
        cat $tmpfile
        command rm -f $tmpfile
    else
        echo 'usage: transfer FILE_TO_TRANSFER'
    end
end

function __my_zoxide_z_complete
    set -l tokens (commandline --current-process --tokenize)
    set -l curr_tokens (commandline --cut-at-cursor --current-process --tokenize)

    if test (count $tokens) -le 2 -a (count $curr_tokens) -eq 1
        set -l query $tokens[2..-1]
        zoxide query --exclude (__zoxide_pwd) --list -- $query
    else
        __zoxide_z_complete
    end
end
complete --erase --command __zoxide_z
complete --command __zoxide_z --no-files --arguments '(__my_zoxide_z_complete)'

# vim paste
function v
    set -l file "$argv[1]"
    if test -z "$file"
        echo "Hata: Dosya adı belirtmeniz gerekiyor."
        return 1
    end

    if test ! -f "$file"
        touch "$file"
    end

    chmod 755 "$file"
    vim -c "set paste" "$file"
end

# vim ile ac
function vw
    if set -q argv[1]
        # Dosyanın varlığını kontrol et ve hata çıktısını dev/null'a yönlendir
        set file (command which $argv[1] 2>/dev/null)
        if test -n "$file"
            echo "Dosya bulundu: $file"
            vim $file
        else
            echo "Dosya bulunamadı: $argv[1]"
        end
    else
        echo "Kullanım: vwhich <dosya_adı>"
    end
end


# https://github.com/oh-my-fish/theme-bobthefish
#set -g theme_display_date no
#set -g theme_newline_cursor yes
#set -g theme_newline_prompt "❯ "
#set -g theme_newline_prompt " "

# https://github.com/jorgebucaran/hydro
set -g hydro_color_prompt red
set -g hydro_symbol_prompt "❱"
set -g hydro_multiline true
set -g hydro_color_pwd black
set -g hydro_color_duration grey

zoxide init fish | source
fzf --fish | source

#fish_add_path /home/kenan/.spicetify
#
set -x FZF_DEFAULT_OPTS "--color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7 --color=fg+:#c0caf5,bg+:#1a1b26,hl+:#7dcfff --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"
