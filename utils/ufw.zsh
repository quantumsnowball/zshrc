ensure ufw || return


ufw.enable() {
    sudo ufw enable
}

ufw.disable() {
    sudo ufw disable
}

ufw.status()  {
    sudo ufw status numbered
}

ufw.status-verbose()  {
    sudo ufw status verbose
}
