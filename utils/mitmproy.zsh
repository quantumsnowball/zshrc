ensure mitmproxy || return


mitmproxy.auto-install-certificate() {
    local proxy_addr="${1:-http://127.0.0.1:8080}"
    local tmp_cert="/tmp/mitmproxy-ca-cert.pem"

    echo "Fetching cert from ${proxy_addr} ..."
    if ! curl -x "$proxy_addr" -sS http://mitm.it/cert/pem -o "$tmp_cert"; then
        echo "${RED}Error: failed to fetch cert from mitmproxy. Ensure mitmproxy is running on ${proxy_addr}.${RESET}" >&2
        return 1
    fi

    # install
    echo "Installing cert ..."
    sudo trust anchor --store "$tmp_cert"

    # cleanup
    echo "Cleaning up ..."
    rm -f "$tmp_cert"

    # verify installation
    if trust list | grep -iq "mitmproxy"; then
        echo "${GREEN}Success: mitmproxy CA certificate is installed and trusted!${RESET}"
    else
        echo "${YELLOW}Warning: certificate store completed, but 'mitmproxy' was not found in trust list.${RESET}" >&2
        return 1
    fi
}
