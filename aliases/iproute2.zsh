    # list links, ip addresses, routes
if [[ "$OSTYPE" == "darwin"* ]]; then
    lslink() { ip link; }
    lsip() { ip addr; }
    lsip4() { ip -4 addr;}
    lsip6() { ip -6 addr;}
    lsroute() { ip route; }
    myip() { ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1 }
else
    alias ip='ip -c'
    lslink() { ip -c -br link; }
    lsip() { ip -c -br addr; }
    lsip4() { ip -c -br -4 addr;}
    lsip6() { ip -c -br -6 addr;}
    lsroute() { ip -c route; }
    myip() { ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1 }
fi
