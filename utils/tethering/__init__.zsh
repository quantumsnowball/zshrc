ensure adb || return


tethering.device() {
    uv run --no-active "$XDG_CONFIG_HOME/zshrc/utils/tethering/device.py" "$@"
}

tethering.info() {
    uv run --no-active "$XDG_CONFIG_HOME/zshrc/utils/tethering/info.py" "$@"
}

tethering.connect() {
    uv run --no-active "$XDG_CONFIG_HOME/zshrc/utils/tethering/connect.py" "$@"
}

tethering.disconnect() {
    uv run --no-active "$XDG_CONFIG_HOME/zshrc/utils/tethering/disconnect.py" "$@"
}
