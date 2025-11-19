from abc import ABC

import ffprobe_streams.result.stream
from ffprobe_streams.rich.lib.field import Entry


class Stream(ABC):
    _s: ffprobe_streams.result.stream.Stream

    def title(self, i: int) -> Entry:
        field = f'[green]Stream {i}[/green]'
        color = 'yellow' if self._s.codec_type == 'video' else 'magenta'
        value = f'[{color}]{self._s.codec_type} [{self._s.duration_hms}][/{color}]'
        return Entry(field, value)
