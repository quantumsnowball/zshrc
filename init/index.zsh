shell_init()
{
    local base=$HOME/.config/zshrc/init


    source $base/history.zsh
    source $base/autocomplete.zsh
    source $base/shell.zsh
    source $base/env.zsh
    source $base/conda.zsh
    source $base/zoxide.zsh
    source $base/fzf.zsh
    source $base/gcloud.zsh
    source $base/man.zsh
}

shell_init

unset -f shell_init
