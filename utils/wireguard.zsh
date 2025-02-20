ensure wg || return


wg.restart () {
    sudo wg-quick down wg0
    sudo wg-quick up wg0
}
wg.status () {
    sudo wg show
}
wg.config () {
    sudo wg showconf wg0
}
