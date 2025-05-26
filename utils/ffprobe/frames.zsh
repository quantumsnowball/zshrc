ffprobe.frames.first.info () {
    # shows the first frame info of a video
    ffprobe \
        -v quiet \
        -output_format json \
        -show_frames \
        -hide_banner\
        -read_intervals "%+#1" \
        $1 | jq
}
