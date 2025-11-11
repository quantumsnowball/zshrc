from ffprobe_streams.result.lib.types import Data
from ffprobe_streams.result.stream.audio import AudioStream
from ffprobe_streams.result.stream.video import VideoStream


class Result:
    def __init__(self, data: Data) -> None:
        self._d = data

    @property
    def streams(self) -> list[VideoStream | AudioStream]:
        streams = []
        for s in self._d['streams']:
            if s["codec_type"] == "video":
                streams.append(VideoStream(s))
            elif s["codec_type"] == "audio":
                streams.append(AudioStream(s))
        return streams

    @property
    def format(self) -> Data:
        return self._d['format']

    @property
    def nb_streams(self) -> int:
        return int(self.format['nb_streams'])
