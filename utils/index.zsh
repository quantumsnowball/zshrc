shell_init()
{
    local base=$HOME/.config/zshrc/utils


    source $base/dir.zsh
    source $base/config.zsh
}

shell_init

unset -f shell_init
