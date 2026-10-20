from typing import Annotated, Literal

import typer
from rich import print

app = typer.Typer(help='tethering connect')


def quest2():
    print('[green]connect quest2[/]')


def s7():
    print('[green]connect s7[/]')


@app.command()
def main(
    target: Annotated[Literal['quest2', 's7'], typer.Argument(help='The target device to connect to')],
) -> None:
    match target:
        case 'quest2':
            quest2()
        case 's7':
            s7()


if __name__ == '__main__':
    app()
