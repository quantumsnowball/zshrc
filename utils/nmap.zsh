# show most connected hosts in LAN
nmap-ls() {
    printf "\033[33m%-15s %s\033[0m\n" 'IP Address' 'Name'
    nmap -sL 192.168.1.0/24 --dns-servers 192.168.1.1 \
        | grep "^Nmap scan report for" \
        | awk '{print $5, $(NF)}' \
        | grep -v '^192\.168' \
        | awk '{gsub(/[()]/, ""); printf "\033[32m%-15s\033[0m %s\n", $2, $1}'
}
