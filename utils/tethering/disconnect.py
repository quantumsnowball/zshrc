import subprocess as sh

from device import main as device
from dhcp import cleanup_dnsmasq_dhcp_server
from network import set_client_wifi
from rich import print


def main() -> None:
    # ensure only one device connected
    if not device():
        return

    # toggle back on client's WiFi
    set_client_wifi(enable=True)

    # reset usb functions on android side
    sh.run(['adb', 'shell', 'svc', 'usb', 'setFunctions', 'mtp'])
    link_res = sh.run(
        ['adb', 'shell', 'ip', '-br', 'link'], capture_output=True, text=True
    )
    link_output = link_res.stdout
    link_active = 'rndis0' in link_output or 'usb0' in link_output
    if not link_active:
        print('[green]Reset USB functions on android side[/]')
    else:
        print('[red]Failed to reset USB functions on android side[/]')

    # clean up any ad-hoc spawn dnsmasq dhcp leftover
    cleanup_dnsmasq_dhcp_server()


if __name__ == '__main__':
    main()
