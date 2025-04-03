alias ffp=ffprobe.streams

ffprobe-streams-old()
{
    python $HOME/.config/zshrc/utils/ffprobe/streams.py "$@"
}

ffprobe.streams.raw-info () {
    ffprobe \
        -v quiet \
        -output_format json \
        -show_streams \
        -hide_banner\
        $1
}
