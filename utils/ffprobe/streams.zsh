alias ffp=ffprobe.streams

ffprobe-streams-old()
{
    python $HOME/.config/zshrc/utils/ffprobe/streams.py "$@"
}

ffprobe.streams.info.raw () {
    ffprobe \
        -v quiet \
        -output_format json \
        -show_streams \
        -hide_banner\
        $1
}
ffprobe.streams.info () {
    ffprobe.streams.info.raw $1 | jq '.streams.[]'
}
