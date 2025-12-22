alias wsl.config-etc-wsl.conf='sudo v /etc/wsl.conf'
alias wsl.config-winhome-wslconfig='v ~/winhost/home/.wslconfig'

wsl.disk-usage() {
    local vhd_path="/mnt/c/WSL/Arch/ext4.vhdx"
    
    echo "${BLUE}--- WSL DISK USAGE REPORT ---${RESET}"

    # 1. Windows Side: VHDX File Size
    if [[ -f "$vhd_path" ]]; then
        local logical_bytes=$(stat -c "%s" "$vhd_path")
        local logical_gib=$(awk "BEGIN {printf \"%.2f\", $logical_bytes/1024/1024/1024}")
        
        local physical_bytes=$(stat -c "%b %B" "$vhd_path" | awk '{print $1 * $2}')
        local physical_gib=$(awk "BEGIN {printf \"%.2f\", $physical_bytes/1024/1024/1024}")
        
        echo "${GREEN}Windows Host View (VHDX):${RESET}"
        echo "  Path:           $vhd_path"
        echo "  Logical Size:   ${logical_gib} GiB (Max File Size)"
        echo "  Physical Size:  ${physical_gib} GiB (Actual SSD Space)"
    else
        echo "${RED}Error: Cannot find VHDX at $vhd_path${RESET}"
        return 1
    fi

    echo ""

    # 2. Linux Side: Internal FS Usage
    echo "${GREEN}Linux Guest View (ext4):${RESET}"
    
    # Capture the used GiB in a variable for the bloat calculation
    local linux_used_gib=$(df --block-size=1 / | awk 'NR==2 {print $3/1024/1024/1024}')

    df --block-size=1 / | awk -v used_val="$linux_used_gib" 'NR==2 {
        total = $2/1024/1024/1024;
        avail = $4/1024/1024/1024;
        pct = $5;
        
        printf "  Total Capacity: %.2f GiB\n", total;
        printf "  Actually Used:  %.2f GiB\n", used_val;
        printf "  Available:      %.2f GiB\n", avail;
        printf "  Utilization:    %s\n", pct;
    }'

    # 3. Bloat Calculation (Physical SSD Space - Linux Actually Used)
    local bloat=$(awk "BEGIN {printf \"%.2f\", $physical_gib - $linux_used_gib}")
    
    echo ""
    echo "${BLUE}Summary:${RESET}"
    echo "  Reclaimable 'Bloat': ${RED}${bloat} GiB${RESET}"
    
    echo "${BLUE}-----------------------------${RESET}"
}
