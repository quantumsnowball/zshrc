ensure curl || return


# query public ip address as seen from Internet
ip.public.addr4 () {
    curl -s -4 ifconfig.me | grep -v '^$'
}
ip.public.addr6 () {
    curl -s -6 ifconfig.me | grep -v '^$'
}
ip.public.addr () {
    ip.public.addr4
    ip.public.addr6
}
ip.public.where-am-i () {
    installed jq && 
        curl -s ipinfo.io | jq ||
        curl -s ipinfo.io
}

() {
    # namespaces
    local ns=(ip net network nic if route gateway sys os)

    alias ${^ns}.public.addr4='ip.public.addr4'
    alias ${^ns}.public.addr6='ip.public.addr6'
    alias ${^ns}.public.addr='ip.public.addr'
    alias ${^ns}.public.where-am-i='ip.public.where-am-i'
}

# helpers
curl.save-url-to-file() {
    [[ -n "$1" && -n "$2" ]] || { echo "Usage: $0 <url> <output_file>" >&2; return 1; }
    [[ -d "${2:h}" ]] || { echo "Error: Directory '${2:h}' does not exist." >&2; return 1; }
    curl --fail --location --output "$2" "$1"
}

curl.save-url-to-directory() {
    [[ -n "$1" && -n "$2" ]] || { echo "Usage: $0 <url> <output_dir>" >&2; return 1; }
    [[ -d "$2" ]] || { echo "Error: Directory '$2' does not exist." >&2; return 1; }
    curl --fail --location --remote-name --output-dir "$2" "$1"
}

