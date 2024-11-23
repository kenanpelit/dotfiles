#!/bin/bash

KITTY_DIR="$HOME/.config/kitty"
FONTS_DIR="$KITTY_DIR/fonts"
FONT_CONF="$KITTY_DIR/font.conf"
ORIGINAL_FONT_CONF="$KITTY_DIR/font.conf.bk"

# Mevcut font.conf'u yedekle
if [ -f "$FONT_CONF" ]; then
    cp "$FONT_CONF" "$ORIGINAL_FONT_CONF"
fi

test_font() {
    local font_conf="$1"
    echo "Testing font configuration: $font_conf"
    cp "$font_conf" "$FONT_CONF"
    kitty --config "$KITTY_DIR/kitty.conf" & 
    pid=$!
    echo "Press Enter to test next font (Ctrl+C to exit)..."
    read
    kill $pid
}

echo "Font Test Starting..."
echo "Each font will open in a new Kitty window."
echo "Press Enter to cycle through fonts."

for conf in "$FONTS_DIR"/*.conf; do
    if [ -f "$conf" ] && [[ "$conf" != *"test-fonts.sh"* ]]; then
        test_font "$conf"
    fi
done

# Test sonrası orijinal font.conf'u geri yükle
if [ -f "$ORIGINAL_FONT_CONF" ]; then
    cp "$ORIGINAL_FONT_CONF" "$FONT_CONF"
    rm "$ORIGINAL_FONT_CONF"
fi

echo "Font testing completed!"
echo "To use a specific font configuration permanently, copy the desired .conf file to font.conf"
echo "Example: cp $FONTS_DIR/firacode.conf $KITTY_DIR/font.conf"
