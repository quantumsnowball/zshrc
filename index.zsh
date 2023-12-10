init_zshrc()
{
    local base=$HOME/.config/zshrc


    source $base/paths/index.zsh

    source $base/init/index.zsh

    source $base/utils/index.zsh

    source $base/plugins/index.zsh

    source $base/aliases/index.zsh
}

init_zshrc

unset -f init_zshrc
