ffmpeg.to-60fps-timescale90000-copy() {
    ffmpeg -i "$1" -c copy -video_track_timescale 90000 "$2"
}

ffmpeg.to-60fps-timescale90000-libx264-aac() {
    ffmpeg -i "$1" -c:v libx264 -c:a aac -video_track_timescale 90000 "$2"
}

