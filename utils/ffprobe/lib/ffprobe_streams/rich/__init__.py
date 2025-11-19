from dataclasses import dataclass

from ffprobe_streams.result import Result
from ffprobe_streams.result.stream.audio import AudioStream
from ffprobe_streams.result.stream.video import VideoStream
from ffprobe_streams.rich.format import Format
from ffprobe_streams.rich.general import General
from ffprobe_streams.rich.stream.audio import Audio
from ffprobe_streams.rich.stream.video import Video
from rich.console import Console
from rich.table import Table


class RichTable:
    def __init__(self, r: Result) -> None:
        self._r = r
        self._table = Table()

        # info
        @dataclass
        class Info:
            general: General
            format: Format
        self.info = Info(General(r), Format(r))

        # helper
        self.add_column = self._table.add_column
        self.add_row = self._table.add_row
        self.add_section = self._table.add_section

    def present(self) -> None:
        # caption
        self._table.title = self.info.general.title

        # format
        self.add_column(self.info.format.title.field)
        self.add_column(self.info.format.title.value)
        self.add_row(*self.info.format.size.tuple)
        self.add_row(*self.info.format.name.tuple)
        self.add_row(*self.info.format.bit_rate.tuple)

        # present streams
        for i, s in enumerate(self._r.streams):
            # video stream
            if isinstance(s, VideoStream):
                v = Video(s)
                self.add_section()
                self.add_row(*v.title(i).tuple)
                self.add_section()
                self.add_row(*v.codec.tuple)
                self.add_row(*v.bit_rate.tuple)
            # audio stream
            elif isinstance(s, AudioStream):
                a = Audio(s)
                self.add_section()
                self.add_row(*a.title(i).tuple)
                self.add_section()
                self.add_row(*a.codec.tuple)
                self.add_row(*a.bit_rate.tuple)

        # print
        console = Console()
        console.print(self._table)
