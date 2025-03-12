installed systemctl || return


systemctl.restart-service () {
    sudo systemctl restart $1
}
systemctl.start-service () {
    sudo systemctl start $1
}
systemctl.stop-service () {
    sudo systemctl start $1
}
systemctl.enable-service () {
    sudo systemctl enable $1
}
systemctl.disable-service () {
    sudo systemctl disable $1
}
systemctl.daemon-reload () {
    sudo systemctl daemon-reload
}
systemctl.ls () {
    sudo systemctl list-unit-files
}
systemctl.ls-grep () {
    sudo systemctl list-unit-files | rg $1
}

