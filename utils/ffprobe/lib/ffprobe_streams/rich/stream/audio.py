from ffprobe_streams.result.stream.audio import AudioStream
from ffprobe_streams.rich.stream import Stream


class Audio(Stream):
    def __init__(self, s: AudioStream) -> None:
        self._s = s
