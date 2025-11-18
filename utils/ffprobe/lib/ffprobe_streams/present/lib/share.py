from ffprobe_streams.lib.ansi_colors import *
from ffprobe_streams.result.format import Format


def print_field_value(field: str, value: str | None, *, tab: bool = True) -> None:
    print(f'{'\t' if tab else ''}{field}: {value}')


def present_subject(nb_streams: int | None) -> None:
    if nb_streams is None or nb_streams <= 0:
        print(f"\n\t< ffprobe: no stream found >\n",)
    print(f"\n\t< ffprobe: total {nb_streams} stream(s) >\n",)


def present_format_title(f: Format) -> None:
    field = f'{GREEN}Format{RESET}'
    filename = f.filename
    if filename is not None and len(filename) >= 60:
        filename = f'{filename[:45]} ... {filename[-10:]}'
    value = f'{CYAN}{filename} [{f.duration_hms}]{RESET}'
    print_field_value(field, value, tab=False)
