from abc import ABC

from ffprobe_streams.result.lib.types import Data


class Stream(ABC):
    def __init__(self, data: Data) -> None:
        self._d = data
