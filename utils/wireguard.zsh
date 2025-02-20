ensure wg || return


wg.restart () {
    sudo wg-quick down wg0
    sudo wg-quick up wg0
}
