from abc import ABC

from ffprobe_streams.result.lib.types import Data
from ffprobe_streams.result.lib.utils import hms


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
        # seconds format
        if (result := self._d['duration']):
            return result
        # HMS format
        if (tags := self._d['tags']) and (result := tags['DURATION']):
            return result
        # else
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
        #
        return hms(total_seconds)

    @property
    def bit_rate(self) -> str | None:
        return self._d['bit_rate']

    @property
    def language(self) -> str | None:
        if (tags := self._d['tags']) and (result := tags['language']):
            return result
        # else
        return None
