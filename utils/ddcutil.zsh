installed ddcutil || return


() {
    # namespaces
    local ns=(ddcutil monitor desktop workstation power sys os)

    # helpers
    alias ${^ns}.power-on-monitor='ddcutil setvcp D6 1'
    alias ${^ns}.power-off-monitor='ddcutil setvcp D6 4'
}
