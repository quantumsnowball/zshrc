shell_init()
{
    local base=$HOME/.config/zshrc/init


    source $base/history.zsh
    source $base/autocomplete.zsh
    source $base/common.zsh
    source $base/env.zsh
    source $base/conda.zsh
    source $base/zoxide.zsh
    source $base/fzf.zsh
    source $base/gcloud.zsh
}

shell_init

unset -f shell_init
