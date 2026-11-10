import curses.ascii
import unicodedata

# header
print(f"{'DEC':>3}  {'HEX':>3}  {'OCT':>3}  {'BINARY':>8}  {'REPR':<8}  {'NAME'}")
print('-' * 55)

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

    print(f'{dec}  {hex_val}  {oct_val}  {bin_val}  {char_repr:<8}  {char_name}')
