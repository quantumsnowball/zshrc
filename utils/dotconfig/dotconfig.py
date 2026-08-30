#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#   "rich",
# ]
# ///

import time

from rich.live import Live
from rich.table import Table

REPO_NAMES = [
    'zshrc',
    'nvim',
    'tmux',
    'workspace',
    'workspace-private',
]


class Repo:
    def __init__(self, name: str) -> None:
        self._name = name

    def pull(self) -> int:
        return 0


class Host:
    def __init__(self, name: str) -> None:
        self._name = name
        self._repos = [Repo(name) for name in REPO_NAMES]

    def pull(self) -> None:
        pass


class Manager:
    def __init__(self, remotes: list[Host]) -> None:
        self._remotes = remotes
        # Create the table structure
        self._table = Table(title='SSH Git Dot Repos')
        self._table.add_column('Repository', style='bold cyan', width=15)
        self._table.add_column('Status', width=12)
        # Add initial rows
        self._table.add_row('nvim', '[yellow]PULLING...[/yellow]')
        self._table.add_row('zsh', '[yellow]PULLING...[/yellow]')
        self._table.add_row('ghostty', '[yellow]PULLING...[/yellow]')

    def pull(self) -> None:
        # Use Live to handle in-place cell updates
        with Live(self._table, refresh_per_second=10):
            time.sleep(1)

            # Update Row 0, Column 1 (nvim)
            self._table.columns[1]._cells[0] = '[bold green]● SUCCESS[/bold green]'

            time.sleep(1)

            # Update Row 2, Column 1 (ghostty)
            self._table.columns[1]._cells[2] = '[bold red]● FAILED[/bold red]'

            time.sleep(1)

            # Update Row 1, Column 1 (zsh)
            self._table.columns[1]._cells[1] = '[bold green]● SUCCESS[/bold green]'

            time.sleep(1)


def main() -> None:
    manager = Manager(remotes=[
        Host('s7'),
        Host('a9'),
        Host('a56'),
    ])
    manager.pull()


if __name__ == '__main__':
    main()
