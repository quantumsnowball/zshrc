ensure iptables || return


# Written and tested on CentOS 7
ip.tables = () {
    sudo iptables -vL | 
        cut -f -9 | 
        column -t | 
        sed 's/^Chain/\n&/g' | 
        sed '/^Chain/ s/[ \t]\{1,\}/ /g' | 
        sed '/^[0-9]/ s/[ \t]\{1,\}/ /10g' | 
        bat --wrap=never --style=grid --color=always
}
