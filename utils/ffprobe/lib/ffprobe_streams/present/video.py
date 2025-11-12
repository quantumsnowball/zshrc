from ffprobe_streams.present.common import *
from ffprobe_streams.result.stream.video import VideoStream


def present(i: int, s: VideoStream) -> None:
    present_stream_title(i, s)
    present_codec(s)
