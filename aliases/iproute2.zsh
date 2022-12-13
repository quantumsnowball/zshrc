    # list links, ip addresses, routes
if [[ "$OSTYPE" == "darwin"* ]]; then
    lslink() { ip link; }
    lsip() { ip addr; }
    lsip4() { ip -4 addr;}
    lsip6() { ip -6 addr;}
    lsroute() { ip route; }
else
    alias ip='ip -c'
    lslink() { ip -br link; }
    lsip() { ip -br addr; }
    lsip4() { ip -br -4 addr;}
    lsip6() { ip -br -6 addr;}
    lsroute() { ip route; }
fi
