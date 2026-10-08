[ -v TERMUX_VERSION ] || return
ensure sv || return


# Note: install termux-services first
# pkg install termux-services
() {
    # namespaces
    local ns=(sv termux-service)

    # aliases
    # termux service management namespace
    alias ${^ns}.enable='sv-enable'
    alias ${^ns}.disable='sv-disable'
    alias ${^ns}.status='sv status'
    alias ${^ns}.list='sv status $PREFIX/var/service/*'
    alias ${^ns}.enabled='sv-enable --list'
    alias ${^ns}.up='sv up'
    alias ${^ns}.down='sv down'
    alias ${^ns}.restart='sv restart'
}
