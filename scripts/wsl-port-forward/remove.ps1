$wsl_ip=(get-hnsendpoint).ipaddress[-1]
$from_port=$args[0]
$to_port=$args[1]

if ($args.count -eq 2) {
    echo "Remove mapping from port $from_port on Windows to port $to_port on WSL at $wsl_ip"
    netsh interface portproxy delete v4tov4 listenport=$from_port listenaddress=0.0.0.0
}
else {
    echo "Usage: wsl-port-forward-remove <from_port> <to_port>"
}
