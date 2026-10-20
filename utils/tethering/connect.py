import sys
from typing import Annotated, Literal

import typer
from rich import print

from utils import foo

app = typer.Typer(help='tethering connect')


@app.command()
def main(
    target: Annotated[Literal['quest2', 's7'], typer.Argument(help='The target device to connect to')],
) -> None:
    print(f'[green]run connect({target})[/]')
    foo()
    print(sys.path)


if __name__ == '__main__':
    app()
