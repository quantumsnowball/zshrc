$wsl_ip=(get-hnsendpoint).ipaddress | Select -Last 1
$from_port=$args[0]
$to_port=$args[1]

if ($args.count -eq 2) {
    echo "Forward from port $from_port on Windows to port $to_port on WSL at $wsl_ip"
    netsh interface portproxy add v4tov4 listenport=$from_port listenaddress=0.0.0.0 connectport=$to_port connectaddress=$wsl_ip
}
else {
    echo "Usage: wsl-port-forward-set <from_port> <to_port>"
}
