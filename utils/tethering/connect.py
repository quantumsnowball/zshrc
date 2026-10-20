from time import sleep
from typing import Annotated, Literal

import typer
from device import main as device
from firewall import firewall_allow_interface
from network import (
    detect_host_interface,
    enable_android_native_tethering,
    remove_all_adb_reverse_channels,
    set_client_wifi,
)
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

    # ensure ufw allow all incoming network traffics for this interface
    sleep(1)
    firewall_allow_interface(host_iface)

    # disable the client's WiFi
    sleep(1)
    set_client_wifi(enable=False)

    # make sure adb reverse is off so only tethering is active
    sleep(1)
    remove_all_adb_reverse_channels()

    #
    sleep(1)
    print('[green]Your USB network is ready![/]')


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
