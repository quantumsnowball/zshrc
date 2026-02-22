installed systemctl || return


# systemctl
sysd.restart-service () {
    sudo systemctl restart $1
}
sysd.start-service () {
    sudo systemctl start $1
}
sysd.stop-service () {
    sudo systemctl start $1
}
sysd.enable-service () {
    sudo systemctl enable $1
}
sysd.disable-service () {
    sudo systemctl disable $1
}
sysd.daemon-reload () {
    sudo systemctl daemon-reload
}
sysd.ls () {
    sudo systemctl list-unit-files
}
sysd.ls-grep () {
    sudo systemctl list-unit-files | rg $1
}

# journalctl
alias sysd.log='journalctl'
sysd.log-for () {
    journalctl -u $1
}
sysd.log.clear () {
    sudo journalctl --rotate
    sudo journalctl --vacuum-time=1s
}
