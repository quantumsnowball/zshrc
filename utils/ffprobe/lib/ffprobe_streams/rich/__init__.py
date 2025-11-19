from dataclasses import dataclass

from ffprobe_streams.result import Result
from ffprobe_streams.rich.format import Format
from ffprobe_streams.rich.general import General
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

    def present(self) -> None:
        # caption
        self._table.title = self.info.general.title

        # format
        self.add_column(self.info.format.title.field)
        self.add_column(self.info.format.title.value)
        self.add_row(*self.info.format.size.tuple)
        self.add_row(*self.info.format.name.tuple)

        # video stream
        self._table.add_section()
        self._table.add_row('dummy', 'dummy')

        # audio stream
        self._table.add_section()
        self._table.add_row('dummy', 'dummy')

        # print
        console = Console()
        console.print(self._table)
