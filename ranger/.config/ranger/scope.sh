#!/usr/bin/env bash

# Güvenlik ve hata kontrolü için bash ayarları
set -o noclobber # Var olan dosyaların üzerine yazılmasını engeller
set -o noglob    # Wildcard genişletmesini devre dışı bırakır
set -o nounset   # Tanımlanmamış değişkenlerin kullanımını engeller
set -o pipefail  # Pipeline'daki herhangi bir komut başarısız olursa, tüm pipeline başarısız olur
IFS=$'\n'        # Satır sonu karakterini ayırıcı olarak kullan

# Bu script ranger dosya yöneticisinde dosya önizlemeleri oluşturmak için kullanılır.
# use_preview_script seçeneği true olarak ayarlandığında çalışır.
# ANSI renk kodları desteklenir.
# STDIN devre dışıdır, bu nedenle interaktif scriptler düzgün çalışmaz.

# Çıkış kodlarının anlamları:
# Kod | Anlamı      | Ranger'ın yapacağı işlem
# ----+-------------+-------------------------
# 0   | başarılı    | stdout'u önizleme olarak göster
# 1   | önizleme yok| Hiçbir önizleme gösterme
# 2   | düz metin   | Dosyanın düz içeriğini göster
# 3   | sabit gen.  | Genişlik değiştiğinde yenileme yapma
# 4   | sabit yüks. | Yükseklik değiştiğinde yenileme yapma
# 5   | ikisi sabit | Hiç yenileme yapma
# 6   | resim       | $IMAGE_CACHE_PATH'deki resmi önizleme olarak göster
# 7   | resim       | Dosyayı doğrudan resim olarak göster

# Script parametreleri
FILE_PATH="${1}"        # Seçili dosyanın tam yolu
PV_WIDTH="${2}"         # Önizleme panelinin genişliği (sığan karakter sayısı)
PV_HEIGHT="${3}"        # Önizleme panelinin yüksekliği (sığan karakter sayısı)
IMAGE_CACHE_PATH="${4}" # Resim önizlemelerinin önbelleğe alınacağı tam yol
PV_IMAGE_ENABLED="${5}" # Resim önizlemeleri etkinse 'True', değilse 'False'

# Dosya uzantısını al ve küçük harfe çevir
FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

# Genel ayarlar
MAXLN=200                 # Maksimum gösterilecek satır sayısı
HIGHLIGHT_SIZE_MAX=262143 # Sözdizimi vurgulaması için maksimum dosya boyutu (256KB)
HIGHLIGHT_TABWIDTH=${HIGHLIGHT_TABWIDTH:-8}
HIGHLIGHT_STYLE=${HIGHLIGHT_STYLE:-pablo}
HIGHLIGHT_OPTIONS="--replace-tabs=${HIGHLIGHT_TABWIDTH} --style=${HIGHLIGHT_STYLE} ${HIGHLIGHT_OPTIONS:-}"
PYGMENTIZE_STYLE=${PYGMENTIZE_STYLE:-autumn}
OPENSCAD_IMGSIZE=${RNGR_OPENSCAD_IMGSIZE:-1000,1000}
OPENSCAD_COLORSCHEME=${RNGR_OPENSCAD_COLORSCHEME:-Tomorrow Night}

# Yardımcı fonksiyonlar
try() { output=$(eval '"$@"'); } # Komut çalıştırma ve çıktısını yakalama
dump() { /bin/echo "$output"; }  # try komutu çıktısını yazdırma
trim() { head -n "$MAXLN"; }     # Çıktıyı maxln satırına kısıtlama

# SIGPIPE hatasını yönetmek için güvenli pipe fonksiyonu
safepipe() {
	"$@"
	test $? = 0 -o $? = 141
}

# Dosya uzantısına göre işleme
handle_extension() {
	case "${FILE_EXTENSION_LOWER}" in
	# Arşiv dosyaları
	a | ace | alz | arc | arj | bz | bz2 | cab | cpio | deb | gz | jar | lha | lz | lzh | lzma | lzo | \
		rpm | rz | t7z | tar | tbz | tbz2 | tgz | tlz | txz | tZ | tzo | war | xpi | xz | Z | zip)
		try als "$FILE_PATH" && { dump | trim && exit 0; }
		try acat "$FILE_PATH" && { dump | trim && exit 3; }
		try bsdtar -lf "$FILE_PATH" && { dump | trim && exit 0; }
		exit 1
		;;

	# RAR arşivleri
	rar)
		try unrar -p- lt "$FILE_PATH" && { dump | trim && exit 0; }
		exit 1
		;;

	# 7z arşivleri
	7z)
		try 7z -p l "$FILE_PATH" && { dump | trim && exit 0; }
		exit 1
		;;

	# PDF dosyaları
	pdf)
		try pdftotext -l 10 -nopgbrk -q "$FILE_PATH" - &&
			{ dump | trim | fmt -s -w "$PV_WIDTH" && exit 0; }
		try mutool draw -F txt -i -- "$FILE_PATH" 1-10 &&
			{ dump | trim | fmt -s -w "$PV_WIDTH" && exit 0; }
		try exiftool "$FILE_PATH" && { dump | trim && exit 0; }
		exit 1
		;;

	# BitTorrent dosyaları
	torrent)
		try transmission-show "$FILE_PATH" && { dump | trim && exit 5; }
		exit 1
		;;

	# OpenDocument dosyaları
	odt | ods | odp | sxw)
		try odt2txt "$FILE_PATH" && { dump | trim && exit 5; }
		try pandoc -s -t markdown -- "$FILE_PATH" && { dump | trim && exit 5; }
		exit 1
		;;

	# HTML dosyaları
	htm | html | xhtml)
		try w3m -dump "$FILE_PATH" &&
			{ dump | trim | fmt -s -w "$PV_WIDTH" && exit 4; }
		try lynx -dump -- "$FILE_PATH" &&
			{ dump | trim | fmt -s -w "$PV_WIDTH" && exit 4; }
		try elinks -dump "$FILE_PATH" &&
			{ dump | trim | fmt -s -w "$PV_WIDTH" && exit 4; }
		;;

	# JSON dosyaları
	json)
		try jq --color-output . "$FILE_PATH" && { dump | trim && exit 5; }
		try python -m json.tool -- "$FILE_PATH" && { dump | trim && exit 5; }
		;;

	# Ses dosyaları
	dff | dsf | wv | wvc)
		try mediainfo "$FILE_PATH" && { dump | trim && exit 5; }
		try exiftool "$FILE_PATH" && { dump | trim && exit 5; }
		;;
	esac
}

# Resim dosyalarını işleme
handle_image() {
	# Birden fazla seçenek olduğunda veya vektör grafiklerinden
	# oluşturulması gerektiğinde önizleme boyutu
	local DEFAULT_SIZE="1920x1080"

	local mimetype="${1}"
	case "${mimetype}" in
	# SVG dosyaları
	image/svg+xml | image/svg)
		convert -- "$FILE_PATH" "$IMAGE_CACHE_PATH" && exit 6
		exit 1
		;;

	# Video dosyaları için küçük resim
	video/*)
		ffmpegthumbnailer -i "$FILE_PATH" -o "$IMAGE_CACHE_PATH" -s 0 && exit 6
		exit 1
		;;

	# Resim dosyaları
	image/*)
		local orientation
		orientation="$(identify -format '%[EXIF:Orientation]\n' -- "$FILE_PATH")"
		# Yönlendirme verisi varsa ve resmin döndürülmesi gerekiyorsa
		if [[ -n "$orientation" && "$orientation" != 1 ]]; then
			# EXIF verisine göre resmi otomatik döndür
			convert -- "$FILE_PATH" -auto-orient "$IMAGE_CACHE_PATH" && exit 6
		fi
		exit 7
		;;

	# Font dosyaları
	application/font* | application/*opentype)
		preview_png="/tmp/$(basename "${IMAGE_CACHE_PATH%.*}").png"
		if fontimage -o "$preview_png" \
			--pixelsize "120" \
			--fontname \
			--pixelsize "80" \
			--text "  ABCDEFGHIJKLMNOPQRSTUVWXYZ  " \
			--text "  abcdefghijklmnopqrstuvwxyz  " \
			--text "  0123456789.:,;(*!?') ff fl fi ffi ffl  " \
			--text "  The quick brown fox jumps over the lazy dog.  " \
			"$FILE_PATH"; then
			convert -- "$preview_png" "$IMAGE_CACHE_PATH" &&
				rm "$preview_png" &&
				exit 6
		else
			exit 1
		fi
		;;
	esac
}

# MIME türüne göre işleme
handle_mime() {
	local mimetype="${1}"
	case "${mimetype}" in
	# RTF ve DOC dosyaları
	text/rtf | *msword)
		try catdoc -- "$FILE_PATH" && { dump | trim && exit 5; }
		exit 1
		;;

	# DOCX, ePub, FB2 dosyaları
	*wordprocessingml.document | */epub+zip | */x-fictionbook+xml)
		try pandoc -s -t markdown -- "$FILE_PATH" && { dump | trim && exit 5; }
		exit 1
		;;

	# Excel dosyaları
	*ms-excel)
		try xls2csv -- "$FILE_PATH" && { dump | trim && exit 5; }
		exit 1
		;;

	# Metin dosyaları
	text/* | */xml)
		if [ "$(stat --printf='%s' -- "$FILE_PATH")" -gt "${HIGHLIGHT_SIZE_MAX}" ]; then
			exit 2
		fi
		if [ "$(tput colors)" -ge 256 ]; then
			local pygmentize_format='terminal256'
			local highlight_format='xterm256'
		else
			local pygmentize_format='terminal'
			local highlight_format='ansi'
		fi
		try safepipe highlight --out-format="${highlight_format}" \
			--force -- "$FILE_PATH" && { dump | trim && exit 5; }
		try safepipe pygmentize -f "${pygmentize_format}" \
			-O "style=${PYGMENTIZE_STYLE}" -- "$FILE_PATH" && { dump | trim && exit 5; }
		exit 2
		;;

	# Resim dosyaları
	image/*)
		# ASCII art olarak önizleme
		try img2txt --gamma=0.6 --width="$PV_WIDTH" -- "$FILE_PATH" && { dump | trim && exit 4; }
		# Terminal için resim önizleme
		try chafa "$FILE_PATH" -c 16 && exit 5
		exit 1
		;;

	# Video ve ses dosyaları
	video/* | audio/*)
		try exiftool "$FILE_PATH" && { dump | trim && exit 5; }
		try mediainfo "$FILE_PATH" && { dump | trim | sed 's/  \+:/: /' && exit 5; }
		exit 1
		;;
	esac
}

# Hiçbir işleyici tarafından ele alınmayan dosyalar için
handle_fallback() {
	echo '----- File Type Classification -----' && file --dereference --brief -- "$FILE_PATH" && exit 5
	exit 1
}

# Ana işlem akışı
MIMETYPE="$(file --dereference --brief --mime-type -- "$FILE_PATH")"
if [ "$PV_IMAGE_ENABLED" = "True" ]; then
	handle_image "$MIMETYPE"
fi
handle_extension
handle_mime "$MIMETYPE"
handle_fallback

exit 1
