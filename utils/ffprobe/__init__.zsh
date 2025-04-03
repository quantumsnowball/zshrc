ensure ffprobe || return


source $HOME/.config/zshrc/utils/ffprobe/streams.zsh

ffprobe-streams () {
    ffprobe \
        -v quiet \
        -output_format json \
        -show_streams \
        -hide_banner\
        $1
}
