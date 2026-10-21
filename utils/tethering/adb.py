import subprocess as sh
from time import sleep

from rich import print
from task import now, task


def detect_client_ip(client_iface: str = 'rndis0') -> str:
    res = sh.run(['adb', 'shell', 'ip', '-4', 'addr', 'show', 'dev', client_iface], capture_output=True, text=True)
    for line in res.stdout.splitlines():
        if 'inet ' in line:
            parts = line.strip().split()
            for part in parts:
                if '/' in part:
                    return part.split('/')[0]
    print(f'[red]Failed to detect Android client IP on {client_iface}[/]')
    raise RuntimeError


def enable_usb0_link_layer_device(*, check_delay: int = 3) -> None:
    @now
    @task('setup usb0 link layer device', halt=True)
    def _() -> None:
        sh.run(['adb', 'shell', 'svc', 'usb', 'setFunctions', 'ncm'])
        sleep(check_delay)
        result = sh.run(['adb', 'shell', 'ip', '-br', 'link'], capture_output=True, text=True)
        if 'usb0' in result.stdout:
            return
        raise RuntimeError


def enable_android_native_tethering(*, check_delay: int = 1) -> None:
    @now
    @task('turn on Android native tethering', halt=True)
    def _() -> None:
        sh.run(['adb', 'shell', 'svc', 'usb', 'setFunctions', 'rndis'])
        sleep(check_delay)
        result = sh.run(['adb', 'shell', 'ip', '-br', 'link'], capture_output=True, text=True)
        if 'rndis0' in result.stdout:
            return
        raise RuntimeError


def disable_android_usb_device() -> None:
    sh.run(['adb', 'shell', 'svc', 'usb', 'setFunctions', 'mtp'])
    link_res = sh.run(
        ['adb', 'shell', 'ip', '-br', 'link'], capture_output=True, text=True
    )
    link_output = link_res.stdout
    link_active = 'rndis0' in link_output or 'usb0' in link_output
    if not link_active:
        print('[green]Reset USB functions on android side[/]')
        return

    print('[red]Failed to reset USB functions on android side[/]')


def remove_all_reverse_channels() -> None:
    print('[yellow]Removing all adb reverse channels ...[/]')
    result = sh.run(['adb', 'reverse', '--remove-all'])
    if result.returncode == 0:
        print('[green]Removed all adb reverse channels[/]')
        return

    print('[red]Failed to remove all adb reverse channels[/]')
