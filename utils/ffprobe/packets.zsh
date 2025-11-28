ffprobe.packets () {
    ffprobe -show_packets $1 | less
}
ffprobe.packets.video () {
    ffprobe -select_streams v -show_packets $1 | less
}
ffprobe.packets.audio () {
    ffprobe -select_streams a -show_packets $1 | less
}
