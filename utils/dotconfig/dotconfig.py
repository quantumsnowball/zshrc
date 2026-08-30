#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#   "rich",
# ]
# ///

import time

from rich.live import Live
from rich.table import Table


class Repo:
    NAMES = (
        'zshrc',
        'nvim',
        'tmux',
        'workspace',
        'workspace-private',
    )

    def __init__(self, name: str) -> None:
        self.name = name

    def pull(self) -> int:
        return 0


class Host:
    NAMES = (
        's7',
        'a9',
        'a56',
    )

    def __init__(self, name: str) -> None:
        self.name = name
        self.repos = [Repo(name) for name in Repo.NAMES]

    def pull(self) -> None:
        pass


class Manager:
    def __init__(self, hosts: list[Host]) -> None:
        self.hosts = hosts
        self._table = Table(title='SSH Host Dot Repos Manager')
        self._table.add_column('Host', style='bold white', width=15)
        for host_name in Host.NAMES:
            self._table.add_column(host_name, style='bold cyan', width=10)
        for repo_name in Repo.NAMES:
            self._table.add_row(repo_name)

    def pull(self) -> None:
        # Use Live to handle in-place cell updates
        with Live(self._table, refresh_per_second=10):
            time.sleep(1)

            # Update Row 0, Column 1 (nvim)
            # self._table.columns[1]._cells[0] = '[bold green]● SUCCESS[/bold green]'

            time.sleep(1)

            # Update Row 2, Column 1 (ghostty)
            # self._table.columns[1]._cells[2] = '[bold red]● FAILED[/bold red]'

            time.sleep(1)

            # Update Row 1, Column 1 (zsh)
            # self._table.columns[1]._cells[1] = '[bold green]● SUCCESS[/bold green]'

            time.sleep(1)


def main() -> None:
    manager = Manager(hosts=[Host(name) for name in Host.NAMES])
    manager.pull()


if __name__ == '__main__':
    main()
