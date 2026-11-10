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
        self.hex_val = f'0x{i:02X}'
        self.oct_val = f'0o{i:03o}'
        self.bin_val = f'{i:09_b}'
        # handle unprintable control chars vs printable chars
        if i == 127:
            self.char_repr = 'DEL'
            self.char_name = 'DELETE'
        elif curses.ascii.isctrl(i):
            self.char_repr = str(curses.ascii.controlnames[i])
            self.char_name = unicodedata.name(chr(i), 'CONTROL CHARACTER')
        elif curses.ascii.isspace(i):
            self.char_repr = repr(chr(i))
            self.char_name = unicodedata.name(chr(i), 'SPACE')
        else:
            self.char_repr = chr(i)
            self.char_name = unicodedata.name(chr(i), '')

    def __iter__(self) -> Iterator[str]:
        yield self.dec
        yield self.hex_val
        yield self.oct_val
        yield self.bin_val
        yield self.char_repr
        yield self.char_name


class Table:
    def __init__(self, rows: int) -> None:
        # header
        self.table = table = RichTable(
            title='ASCII Character Table (0-127)',
            header_style='bold cyan',
            show_lines=False,
        )
        table.add_column('DEC', justify='right', style='bright_white')
        table.add_column('HEX', justify='center', style='yellow')
        table.add_column('OCT', justify='center', style='magenta')
        table.add_column('BINARY', justify='center', style='green')
        table.add_column('REPR', justify='left', style='bold green')
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
