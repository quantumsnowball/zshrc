alias_init() 
{
    local base=$HOME/.config/zshrc/alias
    

    source $base/common.zsh

    if [ -f "/etc/arch-release" ]; then 
        source $base/pacman.zsh
    fi
}

alias_init
