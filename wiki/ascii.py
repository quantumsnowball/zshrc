#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#     "typer",
#     "rich",
# ]
# ///
import curses.ascii
import unicodedata
from typing import Annotated, Iterator

import typer
from rich.console import Console as RichConsole
from rich.table import Table as RichTable


class Row:
    def __init__(self, i: int) -> None:
        self.dec = f'{i:3d}'
        self.hex_val = f'{i:02X}'
        self.bin_val = f'{i:09_b}'

        # handle unprintable control chars vs printable chars
        is_del = i == 127
        is_ctrl = curses.ascii.isctrl(i)
        is_space = curses.ascii.isspace(i)
        self.ctrl_variant = (
            f'^{chr(i + 64)}' if is_ctrl else
            '^?' if is_del else
            ''
        )
        self.char_repr = (
            'DEL' if is_del else
            str(curses.ascii.controlnames[i]) if is_ctrl else
            repr(chr(i)) if is_space else
            chr(i)
        )
        self.char_name = (
            'DELETE' if is_del else
            unicodedata.name(chr(i), 'CONTROL CHARACTER') if is_ctrl else
            unicodedata.name(chr(i), 'SPACE') if is_space else
            unicodedata.name(chr(i), '')
        )

    def __iter__(self) -> Iterator[str]:
        yield self.dec
        yield self.hex_val
        yield self.bin_val
        yield self.ctrl_variant
        yield self.char_repr
        yield self.char_name


class Table:
    def __init__(self, rows: int) -> None:
        # header
        self.table = table = RichTable(
            title='ASCII Character Table (0-127)',
            header_style='bold bright_blue',
            show_lines=False,
        )
        table.add_column('DEC', justify='right', style='bright_green')
        table.add_column('HEX', justify='right', style='bright_yellow')
        table.add_column('BINARY', justify='center', style='bright_red')
        table.add_column('CTRL', justify='center', style='bold magenta')
        table.add_column('REPR', justify='left', style='bold cyan')
        table.add_column('NAME', justify='left', style='dim white')

        # body
        for i in range(rows):
            row = Row(i)
            table.add_row(*row)

    def render(self) -> None:
        # render table to console
        console = RichConsole()
        console.print(self.table)


def main(
    rows: Annotated[int, typer.Argument(max=256, help='ASCII characters to display')] = 128,
) -> None:
    table = Table(rows)
    table.render()


if __name__ == '__main__':
    typer.run(main)
