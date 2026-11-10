#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#     "typer",
#     "rich",
# ]
# ///
import curses.ascii
import unicodedata
from typing import Iterator

import typer
from rich.console import Console as RichConsole
from rich.table import Table as RichTable

EXTRA_NAMES = {
    **{i: name for i, name in enumerate([
        'NULL', 'START OF HEADING', 'START OF TEXT', 'END OF TEXT',
        'END OF TRANSMISSION', 'ENQUIRY', 'ACKNOWLEDGE', 'BELL',
        'BACKSPACE', 'HORIZONTAL TABULATION', 'LINE FEED', 'VERTICAL TABULATION',
        'FORM FEED', 'CARRIAGE RETURN', 'SHIFT OUT', 'SHIFT IN',
        'DATA LINK ESCAPE', 'DEVICE CONTROL 1', 'DEVICE CONTROL 2', 'DEVICE CONTROL 3',
        'DEVICE CONTROL 4', 'NEGATIVE ACKNOWLEDGE', 'SYNCHRONOUS IDLE',
        'END OF TRANSMISSION BLOCK', 'CANCEL', 'END OF MEDIUM', 'SUBSTITUTE', 'ESCAPE',
        'FILE SEPARATOR', 'GROUP SEPARATOR', 'RECORD SEPARATOR', 'UNIT SEPARATOR',
    ])},
    0b0111_1111: 'DELETE'
}


class Row:
    @staticmethod
    def _is_del(i: int) -> bool:
        return i == 127

    @staticmethod
    def _is_ctrl(i: int) -> bool:
        return curses.ascii.isctrl(i)

    @staticmethod
    def _is_cntrl(i: int) -> bool:
        return curses.ascii.iscntrl(i)

    @staticmethod
    def _is_space(i: int) -> bool:
        return curses.ascii.isspace(i)

    @classmethod
    def _char_name(cls, i: int) -> str:
        return unicodedata.name(chr(i), EXTRA_NAMES.get(i, ''))

    @classmethod
    def _char(cls, i: int) -> str:
        return (
            'DEL' if cls._is_del(i) else
            str(curses.ascii.controlnames[i]) if cls._is_ctrl(i) else
            repr(chr(i)) if cls._is_space(i) else
            chr(i)
        )

    @classmethod
    def _ctrl_variant(cls, i: int) -> str:
        i_xor6 = 0x40 ^ i
        i_xor65 = 0x60 ^ i
        if cls._is_cntrl(i):
            char_xor6 = cls._char(i_xor6)
            char_xor65 = cls._char(i_xor65) if not cls._is_cntrl(i_xor65) else None
            return f'^{char_xor6} ^{char_xor65}' if char_xor65 else f'^{char_xor6}'
        elif cls._is_cntrl(i_xor6):
            return '*'
        elif cls._is_cntrl(i_xor65):
            return '**'
        else:
            return ''

    def __init__(self, i: int) -> None:
        self.dec = f'{i:3d}'
        self.hex = f'{i:02X}'
        self.bin = f'{i:09_b}'
        self.ctrl_variant = self._ctrl_variant(i)
        self.char = self._char(i)
        self.char_name = self._char_name(i)

    def __iter__(self) -> Iterator[str]:
        yield self.dec
        yield self.hex
        yield self.bin
        yield self.char_name
        yield self.char
        yield self.ctrl_variant


class Table:
    def __init__(self, start: int, end: int) -> None:
        # header
        self.table = table = RichTable(
            title=f'ASCII Character Table ({start}-{end})',
            header_style='bold bright_blue',
            show_lines=False,
        )
        table.add_column('DEC', justify='right', style='bright_green')
        table.add_column('HEX', justify='right', style='bright_yellow')
        table.add_column('BINARY', justify='center', style='bright_red')
        table.add_column('NAME', justify='left', style='dim white')
        table.add_column('CHAR', justify='left', style='bold cyan')
        table.add_column('CTRL', justify='center', style='bold magenta')

        # body
        for i in range(start, end):
            row = Row(i)
            table.add_row(*row)


class Grid:
    def __init__(self, *tables: Table) -> None:
        self.grid = RichTable.grid()
        self.grid.add_row(*[t.table for t in tables])

    def render(self) -> None:
        console = RichConsole()
        console.print(self.grid)


def main(
    # rows: Annotated[int, typer.Argument(max=256, help='ASCII characters to display')] = 128,
) -> None:
    grid = Grid(
        Table(0, 32),
        Table(32, 64),
        Table(64, 96),
        Table(96, 128),
    )
    grid.render()


if __name__ == '__main__':
    typer.run(main)
