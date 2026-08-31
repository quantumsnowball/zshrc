[ -f ~/dlna-proxy/start ] || return
[ -f ~/__quest2__ ] || return


dlna-proxy.quest2.start() {
    (
        cd ~
        ./dlna-proxy/start
    )
}
