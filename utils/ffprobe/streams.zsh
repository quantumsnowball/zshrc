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
    def c:
    {
        "black": "\u001b[30m",
        "red": "\u001b[31m",
        "green": "\u001b[32m",
        "yellow": "\u001b[33m",
        "blue": "\u001b[34m",
        "magenta": "\u001b[35m",
        "cyan": "\u001b[36m",
        "white": "\u001b[37m",
        "nc": "\u001b[0m",
    };
    def subject(t):
        "\(c.green)\(t)\(c.nc)";
    def important(t):
        "\(c.red)\(t)\(c.nc)";
    def field(t): 
        "\(c.blue)\(t)\(c.nc)";

    subject("Stream \(.index)") + ": \(.codec_type) [\(.duration) seconds]\n" +
    field("\tcodec") + ": " + important("\(.codec_name)") + " (\(.codec_long_name))\n" +
    field("\tresolution") + ": \(.width) x \(.height) px\n" +
    field("\taspect ratio") + ": \(.display_aspect_ratio)\n" +
    field("\tbitrate") + ": \(.bit_rate)\n" +
    field("\tsample rate") + ": \(.sample_rate)\n" +
    field("\tlanguage") + ": \(.language)\n"
    '
}

