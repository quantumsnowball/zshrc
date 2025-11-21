# /// script
# dependencies = [
#     "rich",
# ]
# ///
import subprocess
from pathlib import Path


class Item:
    def __init__(self, path: Path) -> None:
        self.path = path

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

    def __str__(self) -> str:
        return f'{self.size/1e9:,.3f} GB\t{self.path}\n'


class Items:
    def __init__(self, query: str, path: Path, *, max_depth=1) -> None:
        self.query = query
        self.path = path
        self.max_depth = max_depth

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

    def __str__(self) -> str:
        sizes = self.cal_sizes()
        total_size = sum(s[1] for s in sizes)
        txt = f'{total_size/1e6:,.3f} GB\t{self.path}\n'
        for path, size in sizes:
            txt += f'{size/1e6:,.3f} GB\t{path}\n'
        return txt


def main() -> None:
    home = Path.home()

    print("=== Real uv disk usage ===", end='\n\n')

    # Cache
    print("Cache (real data):")
    cache = Item(home/'.cache/uv')
    print(cache)

    # tools
    print("Hard-linked tools environments:")
    tools = Items('.', home/'.local/share/uv/tools')
    print(tools)

    # user envs
    print("Hard-linked user environments:")
    user_envs = Items('.', home/'.uv/venv')
    print(user_envs)

    # project envs under repos
    print("Hard-linked project .venv environments:")
    project_envs = Items(r'^\.venv$', home/'repos', max_depth=10)
    print(project_envs)


if __name__ == "__main__":
    main()
