ensure ffprobe || return


source $HOME/.config/zshrc/utils/ffprobe/streams.zsh

ffprobe-streams () {
    echo 'rewrite ffprobe.streams without depending on python'
}
