from types import SimpleNamespace

from ffprobe_streams.result import Result
from rich.console import Console
from rich.table import Table


class RichTable:
    def __init__(self, r: Result) -> None:
        self._r = r
        self._table = Table()

    @property
    def title(self) -> str:
        nb_streams = self._r.format.nb_streams
        if nb_streams is None or nb_streams <= 0:
            return 'ffprobe: no stream found'
        return f'ffprobe: total {nb_streams} stream(s)'

    def present(self) -> None:
        self._table.title = self.title

        self._table.add_column("Released", justify="right", style="cyan", no_wrap=True)
        self._table.add_column("Title", style="magenta")

        self._table.add_row("Dec 20, 2019", "Star Wars: The Rise of Skywalker", "$952,110,690")
        self._table.add_row("May 25, 2018", "Solo: A Star Wars Story", "$393,151,347")
        self._table.add_row("Dec 15, 2017", "Star Wars Ep. V111: The Last Jedi", "$1,332,539,889")
        self._table.add_row("Dec 16, 2016", "Rogue One: A Star Wars Story", "$1,332,439,889")
        self._table.add_section()
        self._table.add_row("Dec 20, 2019", "Star Wars: The Rise of Skywalker", "$952,110,690")
        self._table.add_row("May 25, 2018", "Solo: A Star Wars Story", "$393,151,347")
        self._table.add_row("Dec 15, 2017", "Star Wars Ep. V111: The Last Jedi", "$1,332,539,889")
        self._table.add_row("Dec 16, 2016", "Rogue One: A Star Wars Story", "$1,332,439,889")

        console = Console()
        console.print(self._table)
