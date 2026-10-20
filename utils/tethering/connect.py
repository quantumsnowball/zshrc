from time import sleep
from typing import Annotated, Literal

import typer
from device import main as device
from network import detect_host_interface, enable_android_native_tethering
from rich import print

from utils import touch_sudo

app = typer.Typer(help='tethering connect')


def quest2() -> None:
    print('[green]connect quest2[/]')


def s7() -> None:
    # get root permission first
    if not touch_sudo():
        return

    # ensure only one device connected
    if not device():
        return

    # toggle on the android native tethering button
    sleep(1)
    if not enable_android_native_tethering():
        return

    # extract host new usb interface name
    sleep(1)
    if not (host_iface := detect_host_interface(name_starts_with='enp0')):
        return


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
