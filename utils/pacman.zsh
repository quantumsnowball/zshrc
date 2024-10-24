# pacman
if command -v pacman &> /dev/null; then 
    alias pm=pacman
    # helpers
    alias system-update='sudo pacman -Syu'
    alias update-system='sudo pacman -Syu'
fi

