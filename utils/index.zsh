shell_init()
{
    local base=$HOME/.config/zshrc/utils


    source $base/helpers.zsh
}

shell_init

unset -f shell_init
