from ffprobe_streams.result.lib.types import Data


class Format:
    def __init__(self, data: Data) -> None:
        self._d = data

    @property
    def nb_streams(self) -> int | None:
        return self._d['nb_streams']
