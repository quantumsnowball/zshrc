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

    @property
    def size(self) -> Entry:
        field = f'[blue]size[/blue]'
        value = ''
        if self._f.size:
            size = float(self._f.size)
            value += f'{size/1e6:.2f} MB'
            if self._f.duration:
                size_per_min = size / float(self._f.duration) * 60
                value += f' ({size_per_min/1e6:.2f} MB/min)'
        return Entry(field, value)

    @property
    def name(self) -> Entry:
        field = f'[blue]name[/blue]'
        format_name = f'[red]{self._f.format_name}[/red]'
        format_long_name = f'[white]{self._f.format_long_name}[/white]'
        value = f'{format_name} ({format_long_name})'
        return Entry(field, value)

    @property
    def bit_rate(self) -> Entry:
        field = f'[blue]bitrate[/blue]'
        v = f'{float(br)/1e6:.3f} Mb/s' if (br := self._f.bit_rate) else None
        value = f'[white]{v}[/white]'
        return Entry(field, value)
