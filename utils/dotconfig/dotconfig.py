#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#   "rich",
# ]
# ///

import time

from rich.live import Live
from rich.table import Table

# 1. Create the table structure
table = Table(title="Git Sync Status")
table.add_column("Repository", style="bold cyan", width=15)
table.add_column("Status", width=12)

# 2. Add initial rows
table.add_row("nvim", "[yellow]PULLING...[/yellow]")
table.add_row("zsh", "[yellow]PULLING...[/yellow]")
table.add_row("ghostty", "[yellow]PULLING...[/yellow]")

# 3. Use Live to handle in-place cell updates
with Live(table, refresh_per_second=10):
    time.sleep(1)

    # Update Row 0, Column 1 (nvim)
    table.columns[1]._cells[0] = "[bold green]● SUCCESS[/bold green]"

    time.sleep(1)

    # Update Row 2, Column 1 (ghostty)
    table.columns[1]._cells[2] = "[bold red]● FAILED[/bold red]"

    time.sleep(1)

    # Update Row 1, Column 1 (zsh)
    table.columns[1]._cells[1] = "[bold green]● SUCCESS[/bold green]"

    time.sleep(1)
