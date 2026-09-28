installed powerprofilesctl || return


# NOTE: if shown ModuleNotFoundError: No module named 'gi' exception
# - run: `uv.pipi pygobject` to install pygobject in the current activate python env

powerprofilesctl.current() {
    powerprofilesctl get
}
powerprofilesctl.set-performance() {
    powerprofilesctl set performance
    powerprofilesctl get
}
powerprofilesctl.set-balanced() {
    powerprofilesctl set balanced
    powerprofilesctl get
}
powerprofilesctl.set-power-saver() {
    powerprofilesctl set power-saver
    powerprofilesctl get
}

() {
    # namespaces
    local ns=(power powerplan)

    #helpers
    alias ${^ns}.current='powerprofilesctl.current'
    alias ${^ns}.set-performance='powerprofilesctl.set-performance'
    alias ${^ns}.set-balanced='powerprofilesctl.set-balanced'
    alias ${^ns}.set-power-saver='powerprofilesctl.set-power-saver'
}
