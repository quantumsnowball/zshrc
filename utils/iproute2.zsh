ensure ip || return


[[ "$OSTYPE" == "darwin"* ]] || alias ip='ip -c'


ip.local.ls-link () { ip -c -br link; }
alias lslink=ip.local.ls-link

ip.local.ls-addr () { ip -c -br addr; }
alias lsip=ip.local.ls-addr

ip.local.ls-addr4 () { ip -c -br -4 addr;}
alias lsip4=ip.local.ls-addr4

ip.local.ls-addr6 () { ip -c -br -6 addr;}
alias lsip6=ip.local.ls-addr6

ip.local.routing-table () { ip -c route; }
alias lsroute=ip.local.routing-table
