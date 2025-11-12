from ffprobe_streams.result.lib.types import Data
from ffprobe_streams.result.lib.utils import hms


class Format:
    def __init__(self, data: Data) -> None:
        self._d = data

    @property
    def filename(self) -> str | None:
        return self._d['filename']

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
    def duration(self) -> str | None:
        return self._d['duration']

    @property
    def duration_hms(self) -> str | None:
        dur = self.duration
        # guard
        if not dur:
            return None
        # if duration is a float str, conver to HMS string
        try:
            total_seconds = float(dur)
        except ValueError:
            return None
        #
        return hms(total_seconds)

    @property
    def size(self) -> str | None:
        return self._d['size']

    @property
    def bit_rate(self) -> str | None:
        return self._d['bit_rate']
