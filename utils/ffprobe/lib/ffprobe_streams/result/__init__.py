from abc import ABC, abstractproperty
from typing import Any

type Data = dict[str, Any]


class Stream(ABC):
    def __init__(self, data: Data) -> None:
        self._d = data


class VideoStream(Stream):
    pass


class AudioStream(Stream):
    pass


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
