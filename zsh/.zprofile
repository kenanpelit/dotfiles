if [ -z "${WAYLAND_DISPLAY}" ] && [[ "${XDG_VTNR}" =~ ^(1|5|6)$ ]]; then
    exec ~/.bin/startup-manager.sh
fi
