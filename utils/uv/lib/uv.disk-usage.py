# /// script
# dependencies = [
#     "rich",
# ]
# ///
import subprocess
from pathlib import Path

from rich import box
from rich.console import Console
from rich.table import Table

WIDTH_COL0 = 15
WIDTH_COL1 = 65
TABLE_WIDTH = WIDTH_COL0 + WIDTH_COL1


class Item:
    def __init__(self, path: Path, *, title: str) -> None:
        self.path = path
        self._t = Table(box=box.HORIZONTALS, width=TABLE_WIDTH)
        self._t.title = title

    @property
    def size(self) -> int:
        try:
            assert self.path.exists()
            result = subprocess.check_output([
                'du', '-sb', '--apparent-size',
                str(self.path)
            ], text=True)
            byte_count = int(result.split()[0])
            return byte_count
        except Exception:
            return 0

    def present(self) -> None:
        self._t.add_column(f'[red]{self.size/1e9:,.3f} GB[/red]', width=WIDTH_COL0, justify='right')
        self._t.add_column(f'[yellow]{self.path}[/yellow]', width=WIDTH_COL1, style='blue')
        # print
        console = Console()
        console.print(self._t)


class Items:
    def __init__(self, query: str, path: Path, *, title: str, max_depth=1) -> None:
        self.query = query
        self.path = path
        self.max_depth = max_depth
        self._t = Table(box=box.HORIZONTALS, width=TABLE_WIDTH)
        self._t.title = title

    def cal_sizes(self) -> list[tuple[Path, int]]:
        try:
            result = subprocess.check_output([
                'fd', '-u',
                '-t', 'd',
                '-d', str(self.max_depth),
                self.query, str(self.path),
                '-X', 'du', '-s', '--apparent-size',
            ], text=True)
            items: list[tuple[Path, int]] = []
            for line in result.strip().splitlines():
                line = line.strip()
                size, path = line.split(maxsplit=1)
                items.append((Path(path), int(size)))
            return sorted(items, key=lambda x: x[1], reverse=True)
        except Exception:
            return []

    def present(self) -> None:
        sizes = self.cal_sizes()
        total_size = sum(s[1] for s in sizes)
        self._t.add_column(f'[red]{total_size/1e6:,.3f} GB[/red]', width=WIDTH_COL0, style='green', justify='right')
        self._t.add_column(f'[yellow]{self.path}[/yellow]', width=WIDTH_COL1, style='blue')
        for path, size in sizes:
            self._t.add_row(f'{size/1e6:,.3f} GB', str(path))
        # print
        console = Console()
        console.print(self._t)


def main() -> None:
    home = Path.home()

    # Cache
    Item(
        home/'.cache/uv',
        title='Cache'
    ).present()

    # tools
    Items(
        '.', home/'.local/share/uv/tools',
        title="Hard-linked tools environments",
    ).present()

    # user envs
    Items(
        '.', home/'.uv/venv',
        title="Hard-linked user environments:",
    ).present()

    # project envs under repos
    Items(
        r'^\.venv$', home/'repos',
        title="Hard-linked project .venv environments:",
        max_depth=10,
    ).present()


if __name__ == "__main__":
    main()
