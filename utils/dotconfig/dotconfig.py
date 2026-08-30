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

    def __init__(self, name: str, row: int, col: int) -> None:
        self.name = name
        self.row = row
        self.col = col
        self.state = 'PULLING'

    def pull(self) -> None:
        self.state = 'SUCCESS'


class Host:
    NAMES = (
        's7',
        'a9',
        'a56',
    )

    def __init__(self, name: str, col: int) -> None:
        self.name = name
        self.col = col
        self.repos = [Repo(name, self.col, i) for i, name in enumerate(Repo.NAMES)]

    def pull(self) -> None:
        for repo in self.repos:
            repo.pull()


class Manager:
    def __init__(self) -> None:
        self.hosts = [Host(name, i) for i, name in enumerate(Host.NAMES)]

    def generate_table(self) -> Table:
        table = Table(title='SSH Host Dot Repos Manager')
        table.add_column('Host', style='bold white', width=20)
        for host_name in Host.NAMES:
            table.add_column(host_name, style='bold cyan', width=10)
        for i, repo_name in enumerate(Repo.NAMES):
            states = [host.repos[i].state for host in self.hosts]
            table.add_row(repo_name, *states)
        return table

    def pull(self) -> None:
        # Use Live to handle in-place cell updates
        with Live(self.generate_table(), refresh_per_second=10) as live:
            time.sleep(1)
            for host in self.hosts:
                host.pull()
            live.update(self.generate_table())
            time.sleep(1)


def main() -> None:
    manager = Manager()
    manager.pull()


if __name__ == '__main__':
    main()
