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
    def pull(self) -> int:
        return 0


class Remote:
    pass


class Manager:
    def __init__(self) -> None:
        # Create the table structure
        self.table = Table(title='SSH Git Dot Repos')
        self.table.add_column('Repository', style='bold cyan', width=15)
        self.table.add_column('Status', width=12)
        # Add initial rows
        self.table.add_row('nvim', '[yellow]PULLING...[/yellow]')
        self.table.add_row('zsh', '[yellow]PULLING...[/yellow]')
        self.table.add_row('ghostty', '[yellow]PULLING...[/yellow]')

    def run(self) -> None:
        # Use Live to handle in-place cell updates
        with Live(self.table, refresh_per_second=10):
            time.sleep(1)

            # Update Row 0, Column 1 (nvim)
            self.table.columns[1]._cells[0] = '[bold green]● SUCCESS[/bold green]'

            time.sleep(1)

            # Update Row 2, Column 1 (ghostty)
            self.table.columns[1]._cells[2] = '[bold red]● FAILED[/bold red]'

            time.sleep(1)

            # Update Row 1, Column 1 (zsh)
            self.table.columns[1]._cells[1] = '[bold green]● SUCCESS[/bold green]'

            time.sleep(1)


def main() -> None:
    manager = Manager()
    manager.run()


if __name__ == '__main__':
    main()
