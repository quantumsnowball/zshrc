init_zshrc()
{
    local base=$HOME/.config/zshrc


    source $base/paths/index.zsh

    source $base/shell/index.zsh

    source $base/plugins/zinit/init.zsh
    source $base/plugins/zinit/loader.zsh
    source $base/plugins/powerlevel10k/init.zsh

    source $base/aliases/index.zsh
}

init_zshrc
