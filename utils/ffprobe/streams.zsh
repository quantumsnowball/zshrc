alias ffp=ffprobe.streams

ffprobe.streams()
{
    python $HOME/.config/zshrc/utils/ffprobe/streams.py "$@"
}

ffprobe-streams () {
    ffprobe \
        -v quiet \
        -output_format json \
        -show_streams \
        -hide_banner\
        $1
}
