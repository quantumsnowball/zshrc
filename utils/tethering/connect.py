from time import sleep
from typing import Annotated, Literal

import typer
from device import main as device
from dhcp import cleanup_dnsmasq_dhcp_server, setup_client_ip, start_dnsmasq_server
from firewall import firewall_allow_interface
from network import (
    detect_host_interface,
    enable_android_native_tethering,
    enable_usb0_link_layer_device,
    remove_all_adb_reverse_channels,
    set_client_wifi,
    setup_host_ip,
)
from ping import ping_from_client_to, ping_from_host
from rich import print

from utils import touch_sudo, usb_connection_ready

app = typer.Typer(help='tethering connect')


def quest2() -> None:
    # special thanks to this tutorial:
    # <https://blog.ronbachmann.dev/posts/quest3-usb-ncm-sunshine>

    # get root permission first
    touch_sudo()

    # ensure only one device connected
    device()

    # enable the usb link layer device
    sleep(1)
    enable_usb0_link_layer_device()

    # extract host new usb interface name
    sleep(1)
    host_iface = detect_host_interface(name_starts_with='enp0')

    # ensure ufw allow all incoming network traffics for this interface
    sleep(1)
    firewall_allow_interface(host_iface, comment='tethering-quest2')

    # network prefix
    network_prefix = '10.77.0'
    host_ip = f'{network_prefix}.1'

    # assign an ip address to the server side
    sleep(1)
    setup_host_ip(host_iface, network_prefix)

    # start a dhcp server on the host and let
    sleep(1)
    start_dnsmasq_server(host_iface, network_prefix)

    # make the android client request an ip through dhcp
    sleep(1)
    setup_client_ip()

    # test the usb connection from client side
    sleep(1)
    ping_from_client_to(host_ip)

    # test the usb connection from host side
    sleep(1)
    ping_from_host(host_iface)

    # disable the client's WiFi
    sleep(1)
    set_client_wifi(enable=False)

    # safely kill the dhcp server
    sleep(1)
    cleanup_dnsmasq_dhcp_server()

    # make sure adb reverse is off so only tethering is active
    sleep(1)
    remove_all_adb_reverse_channels()

    # ready
    sleep(1)
    usb_connection_ready()


def s7() -> None:
    # get root permission first
    touch_sudo()

    # ensure only one device connected
    device()

    # toggle on the android native tethering button
    sleep(1)
    enable_android_native_tethering()

    # extract host new usb interface name
    sleep(1)
    host_iface = detect_host_interface(name_starts_with='enp0')

    # ensure ufw allow all incoming network traffics for this interface
    sleep(1)
    firewall_allow_interface(host_iface, comment='tethering-s7')

    # disable the client's WiFi
    sleep(1)
    set_client_wifi(enable=False)

    # make sure adb reverse is off so only tethering is active
    sleep(1)
    remove_all_adb_reverse_channels()

    # ready
    sleep(1)
    usb_connection_ready()


@app.command()
def main(
    target: Annotated[Literal['quest2', 's7'], typer.Argument(help='The target device to connect to')],
) -> None:
    try:
        match target:
            case 'quest2':
                quest2()
            case 's7':
                s7()
    except RuntimeError:
        print('[red]RuntimeError, stopped[/]')


if __name__ == '__main__':
    app()
