ensure nmap || return

# Target subnet defaults
: "${NMAP_DEFAULT_SUBNET:=192.168.1.0/24}"
: "${NMAP_DEFAULT_DNS:=192.168.1.1}"

# Shared Output Helper
# nmap.parser() {
#     printf "\033[33m%-15s %s\033[0m\n" 'IP Address' 'Name'
#     grep "^Nmap scan report for" \
#         | awk '{print $5, $(NF)}' \
#         | grep -v '^192\.168' \
#         | awk '{gsub(/[()]/, ""); printf "\033[32m%-15s\033[0m %s\n", $2, $1}'
# }

# ==============================================================================
# Discover
# ==============================================================================

# List known hosts in LAN via DNS lookups
nmap.discover.by-dns-lookup() {
    nmap -sL "${1:-$NMAP_DEFAULT_SUBNET}" --dns-servers "$NMAP_DEFAULT_DNS"
}
nmap.discover.by-dns-lookup.show-only-valid-names() {
    nmap.discover.by-dns-lookup "$@" | grep -vE '^Nmap scan report for .*[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'
}

# List active hosts via ping scan
nmap.discover.by-ping() {
    nmap -sn "${1:-$NMAP_DEFAULT_SUBNET}" --dns-servers "$NMAP_DEFAULT_DNS"
}

# ARP sweep local subnet
nmap.discover.by-arp-sweep() {
    nmap -sn -PR "${1:-$NMAP_DEFAULT_SUBNET}"
}

# Find open SSH ports across local network
nmap.discover.ssh-hosts() {
    nmap -p 22,8022 -R --open --dns-servers "$NMAP_DEFAULT_DNS"  "${1:-$NMAP_DEFAULT_SUBNET}"
}

# ==============================================================================
# Scanning
# ==============================================================================

# Fast scan top 20 ports
nmap.scan.top-ports() {
    [[ -z "$1" ]] && { echo "Usage: nmap.scan.top-ports <target>"; return 1; }
    nmap -Pn --top-ports 20 -T4 -R --dns-servers "$NMAP_DEFAULT_DNS" "$1"
}

# Deep service versioning and OS identification
nmap.scan.fingerprint() {
    [[ -z "$1" ]] && { echo "Usage: nmap.scan.fingerprint <target>"; return 1; }
    sudo nmap -Pn -sV -O "$1"
}

# ==============================================================================
# Probing
# ==============================================================================

# Check port status and return exact match reason
nmap.probe.port-reason() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: nmap.probe.port-reason <target> <port>"
        return 1
    fi
    nmap -Pn -p "$2" --reason "$1"
}
