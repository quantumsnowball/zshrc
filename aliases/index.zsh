init_aliases() 
{
    local base=$HOME/.config/zshrc/aliases
    

    source $base/common.zsh

    if [ -f "/etc/arch-release" ]; then 
        source $base/pacman.zsh
    fi
}

init_aliases

unset -f init_aliases
