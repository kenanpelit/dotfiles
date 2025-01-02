if [ -z "${WAYLAND_DISPLAY}" ] && [[ "${XDG_VTNR}" =~ ^(1|5|6)$ ]]; then
    exec ~/.bin/startup-manager.sh

elif [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" = "2" ]; then
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
    exec sway -c ~/.config/sway/qemu-config
fi
