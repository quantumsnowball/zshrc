ensure mitmproxy || return


mitmproxy.auto-install-certificate() {
    local proxy_addr="${1:-http://127.0.0.1:8080}"
    local tmp_cert="/tmp/mitmproxy-ca-cert.pem"

    echo "Fetching cert from ${proxy_addr}..."
    if ! curl -x "$proxy_addr" -sS http://mitm.it/cert/pem -o "$tmp_cert"; then
        echo "Error: failed to fetch cert from mitmproxy. Ensure mitmproxy is running on ${proxy_addr}." >&2
        return 1
    fi

    # install
    echo "Installing cert ..."
    sudo trust anchor --store "$tmp_cert"

    # cleanup
    echo "Cleaning up ..."
    rm -f "$tmp_cert"
}
