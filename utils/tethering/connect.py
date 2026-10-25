from typing import Annotated, Literal

import adb
import device
import dhcp
import firewall
import network
import ping
import typer

import utils

app = typer.Typer(help='tethering connect')


def quest2() -> None:
    # special thanks to this tutorial:
    # <https://blog.ronbachmann.dev/posts/quest3-usb-ncm-sunshine>

    # -- preparation --
    # get root permission first
    utils.acquire_sudo()
    # ensure only one device connected
    device.ensure_single_connection()

    # -- core --
    # enable the usb link layer device
    adb.enable_usb0_link_layer_device()
    # extract host new usb interface name
    host_iface = network.detect_host_iface(name_starts_with='enp0')
    # ensure ufw allow all incoming network traffics for this interface
    firewall.allow(host_iface, comment='tethering-quest2')
    # network prefix
    network_prefix = '10.77.0'
    host_ip = f'{network_prefix}.1'
    # assign an ip address to the server side
    network.assign_host_ip(host_iface, network_prefix)
    # start a dhcp server on the host and let
    dhcp.start_server(host_iface, network_prefix)
    # make the android client request an ip through dhcp
    dhcp.assign_client_ip()

    # -- cleanup --
    # disable the client's WiFi
    network.set_client_wifi(enable=False)
    # safely kill the dhcp server
    dhcp.kill_server()
    # make sure adb reverse is off so only tethering is active
    adb.remove_all_reverse_channels()

    # -- testing --
    # test the usb connection from client side
    client_iface = 'usb0'
    ping.from_client_to_host_ip(host_ip, client_iface)
    # test the usb connection from host side
    ping.from_host(host_iface)

    # -- done --
    # ready
    utils.tethering_connection_ready()


def s7() -> None:
    # -- preparation --
    # get root permission first
    utils.acquire_sudo()
    # ensure only one device connected
    device.ensure_single_connection()

    # -- core --
    # toggle on the android native tethering button
    adb.enable_android_native_tethering()
    # extract host new usb interface name
    host_iface = network.detect_host_iface(name_starts_with='enp0')
    # ensure ufw allow all incoming network traffics for this interface
    firewall.allow(host_iface, comment='tethering-s7')

    # -- cleanup --
    # disable the client's WiFi
    network.set_client_wifi(enable=False)
    # make sure adb reverse is off so only tethering is active
    adb.remove_all_reverse_channels()
    # prevent the tethering network frorm hijacking the Internet route of the host
    network.remove_host_iface_default_route(host_iface)

    # -- testing --
    # test the usb connection from client side
    host_ip = network.detect_host_ip(host_iface)
    ping.from_client_to_host_ip(host_ip)
    # test the usb connection from host side
    client_ip = adb.detect_client_ip(adb.rndis0)
    ping.from_host_to_client_ip(client_ip, host_iface)

    # -- done --
    # ready
    utils.tethering_connection_ready()


@app.command()
@utils.exit_on_runtime_error
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
