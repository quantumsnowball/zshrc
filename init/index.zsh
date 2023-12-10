shell_init()
{
    local base=$HOME/.config/zshrc/init


    source $base/common.zsh
    source $base/env.zsh
    source $base/conda.zsh
    source $base/zoxide.zsh
    source $base/fzf.zsh
}

shell_init

unset -f shell_init
