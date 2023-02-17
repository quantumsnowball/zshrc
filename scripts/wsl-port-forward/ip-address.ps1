$wsl_ip=(get-hnsendpoint).ipaddress | Select -Last 1
echo $wsl_ip
