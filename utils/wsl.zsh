alias wsl.config-etc-wsl.conf='sudo v /etc/wsl.conf'
alias wsl.config-winhome-wslconfig='v ~/winhost/home/.wslconfig'

wsl.disk-usage() {
    # 1. Windows VHDX Size (Physical file size)
    local vhd_path="/mnt/c/WSL/Arch/ext4.vhdx"
    
    echo "--- WSL Disk Usage Report ---"
    
    if [[ -f "$vhd_path" ]]; then
        # Get size in bytes and convert to GB
        local bytes=$(stat -c "%s" "$vhd_path")
        # Using awk for floating point math
        local gb=$(awk "BEGIN {printf \"%.2f\", $bytes/1024/1024/1024}")
        echo "Windows Side: [ $vhd_path ]"
        echo "Current VHDX File Size: $gb GB"
    else
        echo "Error: VHDX not found at $vhd_path"
    fi

    echo "-----------------------------"

    # 2. Linux Internal Usage
    echo "Linux Side: [ Internal ext4 Filesystem ]"
    
    # Extract the row for the root '/' partition
    # awk filters for the line ending in '/' and prints formatted columns
    df -h | awk '$NF == "/" {printf "Total Capacity: %s\nUsed Space:     %s\nAvailable:      %s\nUtilization:    %s\n", $2, $3, $4, $5}'

    echo "-----------------------------"
    
    # Optional: Quick warning if the gap is large
    # Note: 'df' includes filesystem overhead, so it's normal for VHDX to be slightly larger.
}
