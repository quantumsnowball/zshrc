ensure nmap || return

# Target subnet defaults
: "${NMAP_DEFAULT_SUBNET:=192.168.1.0/24}"
: "${NMAP_DEFAULT_DNS:=192.168.1.1}"

# ==============================================================================
# Discover - target a whole subnet
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

# find web servers (80, 443, 8080, 8443)
nmap.discover.web-hosts() {
    nmap -p 80,443,8080,8443 --open -R --dns-servers "$NMAP_DEFAULT_DNS" "${1:-$NMAP_DEFAULT_SUBNET}"
}

# ==============================================================================
# Scanning - target a single host
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
# Probing - target a socket (a host:port pair)
# ==============================================================================

# Check port status and return exact match reason
nmap.probe.port-reason() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: nmap.probe.port-reason <target> <port>"
        return 1
    fi
    nmap -Pn -R --dns-servers "$NMAP_DEFAULT_DNS" -p "$2" --reason "$1"
}

# grab HTTP title and server response headers
nmap.probe.http-info() {
    if [[ -z "$1" ]]; then
        echo "Usage: nmap.probe.http-info <target> [port=80]"
        return 1
    fi
    nmap -Pn -p "${2:-80}" --script http-title,http-headers -R --dns-servers "$NMAP_DEFAULT_DNS" "$1"
}

# inspect SSL/TLS cert info, expiry, and SANs
nmap.probe.ssl-cert() {
    if [[ -z "$1" ]]; then
        echo "Usage: nmap.probe.ssl-cert <target> [port=443]"
        return 1
    fi
    nmap -Pn -p "${2:-443}" --script ssl-cert,ssl-enum-ciphers -R --dns-servers "$NMAP_DEFAULT_DNS" "$1"
}
