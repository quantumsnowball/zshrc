shell_init()
{
    local base=$HOME/.config/zshrc/init


    source $base/common.zsh
    source $base/env.zsh
    source $base/commands.zsh
}

shell_init

unset -f shell_init
