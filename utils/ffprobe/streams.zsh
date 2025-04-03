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
    ffprobe.streams.info.raw $1 | jq '.streams.[] | 
        { 
            index,
            codec_type,
            codec_name,
            codec_long_name,
            bit_rate,
            language: .tags.language,
            duration,

            width,
            height,
            display_aspect_ratio,

            sample_rate,
        }'
}
ffprobe.streams () {
    ffprobe.streams.info $1 | jq -r '
    "Stream \(.index): \(.codec_type) [\(.duration) seconds]\n" +
    "\tcodec: \(.codec_name) (\(.codec_long_name))\n" +
    "\tresolution: \(.width) x \(.height) px\n" +
    "\taspect ratio: \(.display_aspect_ratio)\n" +
    "\tbitrate: \(.bit_rate)\n" +
    "\tsample rate: \(.sample_rate)\n" +
    "\tlanguage: \(.language)\n"
    '
}

