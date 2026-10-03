ensure mitmproxy || return


mitmproxy.install-certificate() {
    [[ -f "$1" ]] || { echo "error: certificate file '$1' not found" >&2; return 1; }
    sudo trust anchor --store "$1"
}

