#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#     "rich",
# ]
# ///
import curses.ascii
import unicodedata

from rich.console import Console
from rich.table import Table

console = Console()

# initialize rich table
table = Table(
    title='ASCII Character Table (0-127)',
    header_style='bold cyan',
    show_lines=False,
)

# add columns with alignment and custom styling
table.add_column('DEC', justify='right', style='bright_white')
table.add_column('HEX', justify='center', style='yellow')
table.add_column('OCT', justify='center', style='magenta')
table.add_column('BINARY', justify='center', style='green')
table.add_column('REPR', justify='left', style='bold green')
table.add_column('NAME', justify='left', style='dim white')

# body
for i in range(128):
    dec = f'{i:3d}'
    hex_val = f'0x{i:02X}'
    oct_val = f'0o{i:03o}'
    bin_val = f'{i:08b}'

    # handle unprintable control chars vs printable chars
    if i == 127:
        char_repr = 'DEL'
        char_name = 'DELETE'
    elif curses.ascii.isctrl(i):
        char_repr = curses.ascii.controlnames[i]
        char_name = unicodedata.name(chr(i), 'CONTROL CHARACTER')
    elif curses.ascii.isspace(i):
        char_repr = repr(chr(i))
        char_name = unicodedata.name(chr(i), 'SPACE')
    else:
        char_repr = chr(i)
        char_name = unicodedata.name(chr(i), '')

    table.add_row(dec, hex_val, oct_val, bin_val, str(char_repr), char_name)

# render table to console
console.print(table)
