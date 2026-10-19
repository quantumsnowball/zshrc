ensure ufw || return


ufw.enable() {
    sudo ufw enable
}

ufw.disable() {
    sudo ufw disable
}

_ufw.status-formatter() {
    awk '
        /To.*Action.*From/ { next }
        /--/               { next }
        {
            sub(/(ALLOW IN|ALLOW OUT|DENY IN|DENY OUT|ALLOW|DENY|REJECT|LIMIT)/, "\n&", $0)
            split($0, parts, "\n")
            printf "%-37s %s\n", parts[1], parts[2]
        }
    '
}

ufw.status() {
    sudo ufw status numbered | _ufw.status-formatter
}

ufw.status-verbose()  {
    sudo ufw status verbose | _ufw.status-formatter
}
