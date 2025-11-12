from ffprobe_streams.result.lib.types import Data


class Format:
    def __init__(self, data: Data) -> None:
        self._d = data

    @property
    def nb_streams(self) -> int | None:
        return self._d['nb_streams']

    @property
    def format_name(self) -> str | None:
        return self._d['format_name']

    @property
    def format_long_name(self) -> str | None:
        return self._d['format_long_name']

    @property
    def bit_rate(self) -> str | None:
        return self._d['bit_rate']
