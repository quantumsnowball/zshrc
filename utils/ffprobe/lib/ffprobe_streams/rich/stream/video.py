from ffprobe_streams.result.stream.video import VideoStream
from ffprobe_streams.rich.stream import Stream


class Video(Stream):
    def __init__(self, s: VideoStream) -> None:
        self._s = s
