if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec ~/.config/hypr/start/hyprland.sh
fi
