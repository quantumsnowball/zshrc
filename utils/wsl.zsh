alias wsl.config-etc-wsl.conf='sudo v /etc/wsl.conf'
alias wsl.config-winhome-wslconfig='v ~/winhost/home/.wslconfig'

wsl.disk-usage() {
    # Path to your VHDX
    local vhd_path="/mnt/c/WSL/Arch/ext4.vhdx"
    
    echo "${CYAN}--- WSL DISK USAGE REPORT ---${RESET}"

    # 1. Windows Side: VHDX File Size
    if [[ -f "$vhd_path" ]]; then
        # stat gets bytes, awk converts to GiB
        local bytes=$(stat -c "%s" "$vhd_path")
        local vhdx_gib=$(awk "BEGIN {printf \"%.2f\", $bytes/1024/1024/1024}")
        
        echo "${GREEN}Windows Host View:${RESET}"
        echo "  Path:      $vhd_path"
        echo "  VHDX Size: ${vhdx_gib} GiB"
    else
        echo "${RED}Error: Cannot find VHDX at $vhd_path${RESET}"
    fi

    echo ""

    # 2. Linux Side: Internal FS Usage
    echo "${GREEN}Linux Guest View (ext4):${RESET}"
    
    # Extract root partition info and append GiB to the numbers
    df -h / | awk 'NR==2 {
        # Replace the "G" suffix with " GiB" for technical accuracy
        gsub(/G/, " GiB", $2); gsub(/G/, " GiB", $3); gsub(/G/, " GiB", $4);
        printf "  Total Capacity: %s\n  Actually Used:  %s\n  Available:      %s\n  Utilization:    %s\n", $2, $3, $4, $5
    }'
    
    echo "${CYAN}-----------------------------${RESET}"
}
