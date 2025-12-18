ffmpeg.to-60fps-timescale90000() {
    ffmpeg -i $1 -c copy -video_track_timescale 90000 $2
}
