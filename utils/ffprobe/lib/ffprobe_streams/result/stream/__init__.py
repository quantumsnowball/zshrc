from abc import ABC

from ffprobe_streams.result.lib.types import Data


class Stream(ABC):
    def __init__(self, data: Data) -> None:
        self._d = data

    @property
    def codec_type(self) -> str | None:
        return self._d['codec_type']

    @property
    def codec_name(self) -> str | None:
        return self._d['codec_name']

    @property
    def codec_long_name(self) -> str | None:
        return self._d['codec_long_name']

    @property
    def duration(self) -> str | None:
        try:
            # could be second or HMS format
            return self._d.get('duration') or \
                self._d['tags'].get('DURATION')
        except KeyError:
            return None

    @property
    def duration_hms(self) -> str | None:
        dur = self.duration
        # guard
        if not dur:
            return None
        # if duration is already HMS format, return as is
        if ':' in dur:
            return dur.split('.')[0]
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
        return self._d.get('bit_rate')

    @property
    def language(self) -> str | None:
        try:
            return self._d['tags'].get('language')
        except KeyError:
            return None
