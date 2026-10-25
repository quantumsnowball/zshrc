import subprocess as sh
from enum import Enum
from time import sleep

from rich import print
from task import now, task


class ClientIface(str, Enum):
    RNDIS0 = 'rndis0'
    USB0 = 'usb0'


rndis0 = ClientIface.RNDIS0
usb0 = ClientIface.USB0


def detect_client_ip(client_iface: ClientIface) -> str:
    @task(f'detect client IP on {client_iface}', halt=True)
    def f() -> str:
        result = sh.run(['adb', 'shell', 'ip', '-4', 'addr', 'show', 'dev', client_iface], capture_output=True, text=True)
        for line in result.stdout.splitlines():
            if 'inet ' in line:
                parts = line.strip().split()
                for part in parts:
                    if '/' in part:
                        ip_addr = part.split('/')[0]
                        print(f'[green]Detected IP [cyan]{ip_addr}[/] on interface {client_iface}[/]')
                        return ip_addr
        #
        raise RuntimeError
    #
    return f()


def enable_usb0_link_layer_device(*, check_delay: int = 3) -> None:
    @now
    @task('setup usb0 link layer device', halt=True)
    def _() -> None:
        # NCM (Network Control Model)
        # activates USB Ethernet Tethering using the modern CDC-NCM protocol (Android 12 or later)
        sh.run(['adb', 'shell', 'svc', 'usb', 'setFunctions', 'ncm'])
        sleep(check_delay)
        result = sh.run(['adb', 'shell', 'ip', '-br', 'link'], capture_output=True, text=True)
        if not 'usb0' in result.stdout:
            raise RuntimeError


def enable_android_native_tethering(*, check_delay: int = 1) -> None:
    @now
    @task('turn on Android native tethering', halt=True)
    def _() -> None:
        # RNDIS (Remote Network Driver Interface Specification)
        # ask service manager to change USB device into tethering network protocol (Android 11 or earlier)
        sh.run(['adb', 'shell', 'svc', 'usb', 'setFunctions', 'rndis'])
        sleep(check_delay)
        result = sh.run(['adb', 'shell', 'ip', '-br', 'link'], capture_output=True, text=True)
        if not 'rndis0' in result.stdout:
            raise RuntimeError


def disable_android_usb_device() -> None:
    @now
    @task('reset USB device on android side')
    def _() -> None:
        # MTP (Media Transfer Protocol)
        # turning on this mode disable any tethering network device
        sh.run(['adb', 'shell', 'svc', 'usb', 'setFunctions', 'mtp'])
        link_res = sh.run(
            ['adb', 'shell', 'ip', '-br', 'link'], capture_output=True, text=True
        )
        link_output = link_res.stdout
        link_active = 'rndis0' in link_output or 'usb0' in link_output
        if link_active:
            raise RuntimeError


def remove_all_reverse_channels() -> None:
    @now
    @task('remove all adb reverse channels')
    def _() -> None:
        if sh.run(['adb', 'reverse', '--remove-all']).returncode != 0:
            raise RuntimeError
