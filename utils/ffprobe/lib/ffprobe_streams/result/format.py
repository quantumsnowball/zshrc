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
        hours = int(total_seconds // 3600)
        remaining_seconds_after_hours = total_seconds % 3600
        minutes = int(remaining_seconds_after_hours // 60)
        seconds = int(remaining_seconds_after_hours % 60)
        hms = f"{hours:02d}:{minutes:02d}:{seconds:02d}"
        return hms

    @property
    def bit_rate(self) -> str | None:
        return self._d['bit_rate']
