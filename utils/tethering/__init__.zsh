ensure adb || return


tethering.device() {
    uv run "$XDG_CONFIG_HOME/zshrc/utils/tethering/device.py" "$@"
}

tethering.info() {
    uv run "$XDG_CONFIG_HOME/zshrc/utils/tethering/info.py" "$@"
}

tethering.ping-test() {
    uv run "$XDG_CONFIG_HOME/zshrc/utils/tethering/ping.py" "$@"
}

tethering.connect() {
    sudo.now
    uv run "$XDG_CONFIG_HOME/zshrc/utils/tethering/connect.py" "$@"
}

tethering.disconnect() {
    uv run "$XDG_CONFIG_HOME/zshrc/utils/tethering/disconnect.py" "$@"
}
