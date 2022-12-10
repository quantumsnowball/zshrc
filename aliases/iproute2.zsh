alias ip='ip -c'
# list links, ip addresses, routes
lslink() { ip -br link; }
lsip() { ip -br addr; }
lsip4() { ip -br -4 addr;}
lsip6() { ip -br -6 addr;}
lsroute() { ip route; }

