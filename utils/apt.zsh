# apt
if command -v apt &> /dev/null; then 
    alias apti='sudo apt install'
    alias apts='sudo apt search'
    alias aptrm='sudo apt remove'
    alias aptu='sudo apt update'
    alias aptup='sudo apt update && sudo apt upgrade'
    # helpers
    alias system-update='aptup'
    alias update-system='aptup'
fi

