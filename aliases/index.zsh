init_aliases() 
{
    local base=$HOME/.config/zshrc/aliases
    

    source $base/dir.zsh
    source $base/common.zsh
    source $base/eza.zsh
    source $base/nvim.zsh
    source $base/tmux.zsh
    source $base/docker.zsh
    source $base/rclone.zsh
    source $base/lazygit.zsh
    source $base/env.zsh
    source $base/git.zsh
    source $base/python.zsh
    source $base/zoxide.zsh
    source $base/iproute2.zsh
    source $base/socket.zsh
    source $base/youtube-dl.zsh

    if [ -f "/etc/arch-release" ]; then 
        source $base/pacman.zsh
    fi
}

init_aliases

unset -f init_aliases
