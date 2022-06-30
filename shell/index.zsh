shell_init()
{
    local base=$HOME/.config/zshrc/shell


    source $base/common.zsh
    source $base/env.zsh
    source $base/commands.zsh
    source $base/utils.zsh
}

shell_init

unset -f shell_init
