if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -le 6 ]; then
    exec ~/.bin/startup-manager.sh
fi
