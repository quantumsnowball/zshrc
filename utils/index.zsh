shell_init()
{
    local base=$HOME/.config/zshrc/utils


    source $base/dir.zsh
    source $base/config.zsh
    source $base/zoxide.zsh
    source $base/python.zsh
    source $base/conda.zsh
    source $base/memory.zsh
    source $base/ffmpeg/index.zsh
}

shell_init

unset -f shell_init
