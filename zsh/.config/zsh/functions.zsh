# Additional Functions
function wanip() {
   local ip
   ip=$(curl -s https://am.i.mullvad.net/ip 2>/dev/null) && echo "Mullvad IP: $ip" && return 0
   ip=$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null) && echo "OpenDNS IP: $ip" && return 0
   ip=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com 2>/dev/null | tr -d '"') && echo "Google DNS IP: $ip" && return 0
   echo "Error: Could not determine IP address"
   return 1
}

# Network & SSH
function transfer() {  
   if [ -z "$1" ]; then
       echo "usage: transfer FILE_TO_TRANSFER"
       return 1
   fi
   tmpfile=$(mktemp -t transferXXX)
   curl --progress-bar --upload-file "$1" "https://transfer.sh/$(basename $1)" >> $tmpfile
   cat $tmpfile
   rm -f $tmpfile
}

# Dosya oluştur/düzenle
function v() {
   local file="$1"
   if [[ -z "$file" ]]; then
       echo "Error: File name required."
       return 1
   fi
   [[ ! -f "$file" ]] && touch "$file"
   chmod 755 "$file"
   vim -c "set paste" "$file"
}

# Komut yolunu bul ve düzenle
function vw() {
   local file
   if [[ -n "$1" ]]; then
       file=$(which "$1" 2>/dev/null)
       if [[ -n "$file" ]]; then
           echo "File found: $file"
           vim "$file"
       else
           echo "File not found: $1"
       fi
   else
       echo "Usage: vwhich <filename>"
   fi
}

# show the list of packages that need this package - depends mpv as example
function_depends()  {
    search=$(echo "$1")
    sudo pacman -Sii $search | grep "Required" | sed -e "s/Required By     : //g" | sed -e "s/  /\n/g"
    }

alias depends='function_depends'

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


