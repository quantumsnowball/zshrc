zsh_init()
{
    local base=$HOME/.config/zshrc


    source $base/path/index.zsh

    source $base/zsh/init.zsh
    source $base/zsh/env.zsh
    source $base/zsh/commands.zsh
    source $base/zsh/utils.zsh

    source $base/plugins/zinit/init.zsh
    source $base/plugins/zinit/loader.zsh
    source $base/plugins/powerlevel10k/init.zsh

    source $base/alias/index.zsh
}

zsh_init
