init_plugins()
{
    local base=$HOME/.config/zshrc/plugins


    source $base/zinit/init.zsh
    source $base/zinit/loader.zsh

    source $base/p10k.zsh
}

init_plugins

unset -f init_plugins
