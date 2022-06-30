init_paths()
{
    local base=$HOME/.config/zshrc/paths


    source $base/common.zsh

    if [[ "$OSTYPE" == "darwin"* ]]; then 
        source $base/homebrew.zsh
    fi
}

init_paths

unset -f init_paths
