# apt
if command -v apt &> /dev/null; then 
    alias apti='sudo apt install'
    alias apts='apt search'
    alias aptls='apt list'
    alias aptgrep='apt list | rg'
    alias aptrg=aptgrep
    alias aptrm='sudo apt remove'
    alias aptu='sudo apt update'
    alias aptup='sudo apt update && sudo apt upgrade'
fi

