ensure dms || return


() {
    # namespaces
    local ns=(dms desktop workstation power sys os)

    # helpers
    alias ${^ns}.lock-and-outputs-off="dms ipc call lock lockAndOutputsOff"
}
