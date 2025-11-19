from ffprobe_streams.result import Result
from ffprobe_streams.rich.lib.field import Entry


class Format:
    def __init__(self, r: Result) -> None:
        self._f = r.format

    @property
    def title(self) -> Entry:
        field = '[green]Format[/green]'
        filename = self._f.filename
        if filename is not None and len(filename) >= 60:
            filename = f'{filename[:45]} ... {filename[-10:]}'
        value = f'[cyan]{filename} [{self._f.duration_hms}][/cyan]'
        return Entry(field, value)
