# /// script
# dependencies = [
#     "rich",
# ]
# ///
import subprocess
from pathlib import Path

from rich.console import Console
from rich.table import Table

WIDTH_COL0 = 13
WIDTH_COL1 = 42
WIDTH_COL2 = 25
TABLE_WIDTH = WIDTH_COL0 + WIDTH_COL1 + WIDTH_COL2


def to_tilda(path: Path) -> str:
    return f'~/{path.relative_to(Path.home())}'


class Item:
    def __init__(self, path: Path, *, title: str) -> None:
        self.path = path
        self._t = Table(box=None, width=TABLE_WIDTH)
        self._t.title = title
        self._t.title_style = 'white'
        self._t.title_justify = 'left'

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
        self._t.add_column(f'[yellow]{to_tilda(self.path)}[/yellow]', width=WIDTH_COL1, style='blue')
        self._t.add_column('', width=WIDTH_COL2)
        # print
        console = Console()
        console.print(self._t)
        console.print('')


class Items:
    def __init__(self, query: str, path: Path, *, title: str, max_depth=1) -> None:
        self.query = query
        self.path = path
        self.max_depth = max_depth
        self._t = Table(box=None, width=TABLE_WIDTH)
        self._t.title = title
        self._t.title_style = 'white'
        self._t.title_justify = 'left'

    def cal_sizes(self) -> list[tuple[Path, int]]:
        try:
            assert self.path.exists()
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

    def get_venv_python_version_cfg(self, path: Path) -> str:
        try:
            # try the best to locate the venv's internal python binary
            py_bin = path/'bin'/'python'
            py_bin = py_bin if py_bin.exists() else path/'bin'/'python3'
            # extract info by running the binary
            if py_bin.exists():
                # python cmd string to output version and gil info
                py_cmd = (
                    "import sys; "
                    "v = f'{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}'; "
                    "g = sys._is_gil_enabled() if hasattr(sys, '_is_gil_enabled') else True; "
                    "print(f'{v}|{g}')"
                )
                # read text output, expecting pattern: "3.14.4|True" or "3.14.4|False"
                output = subprocess.check_output(
                    [str(py_bin), '-c', py_cmd],
                    text=True, stderr=subprocess.DEVNULL
                ).strip()
                # if pattern is valid, parse the output and return the answer
                if output and '|' in output:
                    version, gil_enabled = output.split('|', 1)
                    is_freethreaded = (gil_enabled == 'False')
                    return f'{version}t' if is_freethreaded else version
            # on default
            return 'n.a.'
        except Exception:
            # on exception
            return 'error'

    def present(self) -> None:
        sizes = self.cal_sizes()
        total_size = sum(s[1] for s in sizes)
        self._t.add_column(f'[red]{total_size/1e6:,.3f} GB[/red]', width=WIDTH_COL0, style='green', justify='right')
        self._t.add_column(f'[yellow]{to_tilda(self.path)}[/yellow]', width=WIDTH_COL1, style='blue')
        self._t.add_column('', width=WIDTH_COL2)
        for path, size in sizes:
            self._t.add_row(f'{size/1e6:,.3f} GB', to_tilda(path), self.get_venv_python_version_cfg(path))
        # print
        console = Console()
        console.print(self._t)
        console.print('')


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
        title='Tools environments',
    ).present()

    # user envs
    Items(
        '.', home/'.uv/venv',
        title='User environments',
    ).present()

    # project envs under repos
    Items(
        r'^\.venv$', home/'repos',
        title='Project .venv environments',
        max_depth=10,
    ).present()


if __name__ == '__main__':
    main()
