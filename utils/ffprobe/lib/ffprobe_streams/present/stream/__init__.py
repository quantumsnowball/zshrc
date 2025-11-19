from abc import ABC
from typing import Generic, TypeVar

import ffprobe_streams.result.stream
from ffprobe_streams.present.lib.field import Entry

T = TypeVar('T', bound=ffprobe_streams.result.stream.Stream)


class Stream(ABC, Generic[T]):
    _s: T

    def __init__(self, s: T) -> None:
        self._s = s

    def title(self, i: int) -> Entry:
        field = f'[green]Stream {i}[/green]'
        color = 'yellow' if self._s.codec_type == 'video' else 'magenta'
        value = f'[{color}]{self._s.codec_type} [{self._s.duration_hms}][/{color}]'
        return Entry(field, value)

    @property
    def codec(self) -> Entry:
        field = f'[blue]codec[/blue]'
        codec_name = f'[red]{self._s.codec_name}[/red]'
        codec_long_name = f'[white]{self._s.codec_long_name}[/white]'
        value = f'{codec_name} ({codec_long_name})'
        return Entry(field, value)

    @property
    def bit_rate(self) -> Entry:
        field = f'[blue]bitrate[/blue]'
        v = f'{float(br)/1000:.3f} kb/s' if (br := self._s.bit_rate) else None
        value = f'[white]{v}[/white]'
        return Entry(field, value)

    @property
    def language(self) -> Entry:
        field = f'[blue]language[/blue]'
        value = f'[white]{v}[/white]' if (v := self._s.language) else None
        return Entry(field, value)
