ensure iptables || return


# Written and tested on CentOS 7
ip.tables = () {
    sudo iptables -vL --line-numbers | 
        cut -f -9 | 
        column -t | 
        sed 's/^Chain/\n&/g' | 
        sed '/^Chain/ s/[ \t]\{1,\}/ /g' | 
        sed '/^[0-9]/ s/[ \t]\{1,\}/ /10g' | 
        bat --wrap=never --style=grid --color=always
}

ip.tables.input = () {
    sudo iptables -vL INPUT --line-numbers
}
ip.tables.forward = () {
    sudo iptables -vL FORWARD --line-numbers
}
ip.tables.output = () {
    sudo iptables -vL OUTPUT --line-numbers
}
