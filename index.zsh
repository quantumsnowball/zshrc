zsh_init()
{
    local base=$HOME/.config/zshrc


    source $base/path/index.zsh

    source $base/shell/index.zsh

    source $base/plugins/zinit/init.zsh
    source $base/plugins/zinit/loader.zsh
    source $base/plugins/powerlevel10k/init.zsh

    source $base/alias/index.zsh
}

zsh_init
