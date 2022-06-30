path_init()
{
    local base=$HOME/.config/zshrc/path


    source $base/common.zsh

    if [[ "$OSTYPE" == "darwin"* ]]; then 
        source $base/homebrew.zsh
    fi
}

path_init
