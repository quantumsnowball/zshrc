from typing import Annotated, Literal

import ping
import typer
from adb import (
    detect_client_rndis_ip,
    enable_android_native_tethering,
    enable_usb0_link_layer_device,
    remove_all_adb_reverse_channels,
)
from device import main as device
from dhcp import cleanup_dnsmasq_dhcp_server, setup_client_ip, start_dnsmasq_server
from firewall import firewall_allow_interface
from network import (
    detect_host_interface,
    detect_host_rndis_ip,
    set_client_wifi,
    setup_host_ip,
)

from utils import exit_on_runtime_error, touch_sudo, usb_connection_ready

app = typer.Typer(help='tethering connect')


def quest2() -> None:
    # special thanks to this tutorial:
    # <https://blog.ronbachmann.dev/posts/quest3-usb-ncm-sunshine>

    # get root permission first
    touch_sudo()
    # ensure only one device connected
    device()
    # enable the usb link layer device
    enable_usb0_link_layer_device()
    # extract host new usb interface name
    host_iface = detect_host_interface(name_starts_with='enp0')
    # ensure ufw allow all incoming network traffics for this interface
    firewall_allow_interface(host_iface, comment='tethering-quest2')
    # network prefix
    network_prefix = '10.77.0'
    host_ip = f'{network_prefix}.1'
    # assign an ip address to the server side
    setup_host_ip(host_iface, network_prefix)
    # start a dhcp server on the host and let
    start_dnsmasq_server(host_iface, network_prefix)
    # make the android client request an ip through dhcp
    setup_client_ip()
    # test the usb connection from client side
    client_iface = 'usb0'
    ping.from_client_to_host_ip(host_ip, client_iface)
    # test the usb connection from host side
    ping.from_host(host_iface)
    # disable the client's WiFi
    set_client_wifi(enable=False)
    # safely kill the dhcp server
    cleanup_dnsmasq_dhcp_server()
    # make sure adb reverse is off so only tethering is active
    remove_all_adb_reverse_channels()
    # ready
    usb_connection_ready()


def s7() -> None:
    # get root permission first
    touch_sudo()
    # ensure only one device connected
    device()
    # toggle on the android native tethering button
    enable_android_native_tethering()
    # extract host new usb interface name
    host_iface = detect_host_interface(name_starts_with='enp0')
    # ensure ufw allow all incoming network traffics for this interface
    firewall_allow_interface(host_iface, comment='tethering-s7')
    # test the usb connection from client side
    host_ip = detect_host_rndis_ip(host_iface)
    ping.from_client_to_host_ip(host_ip)
    # test the usb connection from host side
    client_ip = detect_client_rndis_ip()
    ping.from_host_to_client_ip(client_ip, host_iface)
    # disable the client's WiFi
    set_client_wifi(enable=False)
    # make sure adb reverse is off so only tethering is active
    remove_all_adb_reverse_channels()
    # ready
    usb_connection_ready()


@app.command()
@exit_on_runtime_error
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
