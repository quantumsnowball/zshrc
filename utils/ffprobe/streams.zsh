alias ffp=ffprobe.streams

ffprobe-streams-old()
{
    python $HOME/.config/zshrc/utils/ffprobe/streams.py "$@"
}

ffprobe.streams.info.raw () {
    # raw json output by ffprobe
    ffprobe \
        -v quiet \
        -output_format json \
        -show_streams \
        -hide_banner\
        $1
}
ffprobe.streams.info () {
    # select interesting info for further processing
    ffprobe.streams.info.raw $1 | jq '
    [
        .streams.[] | { 
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
        }
    ]'
}
ffprobe.streams () {
    # based on the selected info, print a user readabile format
    ffprobe.streams.info $1 | jq -r '
    # define colors
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
    # helpers
    def subject(t):
        "\(c.green)\(t)\(c.nc)";
    def codec(t):
        "\(c.red)\(t)\(c.nc)";
    def field(t): 
        "\(c.blue)\(t)\(c.nc)";
    def media(v; t):
        if v == "video" then
            "\(c.yellow)\(t)\(c.nc)"
        elif v == "audio" then
            "\(c.magenta)\(t)\(c.nc)"
        else
            "\(t)"
        end;
    def to_hms:
        tonumber as $sec | 
        ($sec / 3600 | floor | tostring | "00\(.)"[-2:]) as $h |
        ($sec % 3600 / 60 | floor | tostring | "00\(.)"[-2:]) as $m |
        ($sec % 60 | tostring | "00\(.)"[-2:]) as $s |
        "\($h):\($m):\($s)";
    def assert(v; t):
        if v != null then
            "\(t)"
        else ""
        end;


    # subject line
    "\n\t< ffprobe: total \(. | length) stream(s) >\n",

    # for each stream in .[]
    (.[] |
        # print subject line, stream index, media type and duration
        subject("Stream \(.index)") + ": " + media(.codec_type; "\(.codec_type) [\(.duration | to_hms)]\n") 
        
        # print fields and values
        + assert(.codec_name;
            field("\tcodec") + ": " + codec("\(.codec_name)") + " (\(.codec_long_name))\n") 
        + assert(.width; assert(.height;
            field("\tresolution") + ": \(.width) x \(.height) px\n"))
        + assert(.display_aspect_ratio;
            field("\taspect ratio") + ": \(.display_aspect_ratio)\n")
        + assert(.bit_rate;
            field("\tbitrate") + ": \(.bit_rate | tonumber / 1000) kb/s\n")
        + assert(.sample_rate; 
            field("\tsample rate") + ": \(.sample_rate) hz\n") 
        + assert(.language;
            field("\tlanguage") + ": \(.language)\n")
    )

    '
}

