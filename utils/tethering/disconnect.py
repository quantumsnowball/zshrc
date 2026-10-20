import subprocess as sh
from pathlib import Path
from time import sleep

from device import main as device
from rich import print

from utils import set_client_wifi

DNSMASQ_PID_PATH = Path('/tmp/tethering_dnsmasq.pid')


def cleanup_dnsmasq_dhcp_server() -> None:
    path = DNSMASQ_PID_PATH
    if path.is_file():
        pid = path.read_text().strip()
        if pid:
            sh.run(['sudo', 'kill', pid], stdout=sh.DEVNULL, stderr=sh.DEVNULL)
        path.unlink()
        print('[green]Done clean up any ad-hoc spawn dnsmasq DHCP process[/]')


def main() -> None:
    # ensure only one device connected
    if not device():
        return

    # toggle back on client's WiFi
    sleep(1)
    set_client_wifi(enable=True)

    # reset usb functions on android side
    sleep(1)
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
    sleep(1)
    cleanup_dnsmasq_dhcp_server()


if __name__ == '__main__':
    main()
