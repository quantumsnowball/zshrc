import subprocess as sh
from time import sleep

from rich import print


def set_client_wifi(*, enable: bool) -> None:
    result = sh.run(['adb', 'shell', 'svc', 'wifi', 'enable' if enable else 'disable'])
    if result.returncode == 0:
        print("[green]Toggled back on client's WiFi[/]")
    else:
        print("[red]Failed to toggle back on client's WiFi[/]")


def enable_android_native_tethering(*, check_delay: int = 1) -> bool:
    print('[yellow]Turning on Android native tethering ...[/]')
    sh.run(['adb', 'shell', 'svc', 'usb', 'setFunctions', 'rndis'])
    sleep(check_delay)
    result = sh.run(['adb', 'shell', 'ip', '-br', 'link'], capture_output=True, text=True)
    if 'rndis0' in result.stdout:
        print('[green]Turned on Android native tethering[/]')
        return True
    else:
        print('[red]Failed to turn on Android native tethering[/]')
        return False


def detect_host_interface(*, name_starts_with: str) -> str | None:
    print('[yellow]Detecting host USB interface ...[/]')
    result = sh.run(['ip', '-br', 'link', 'show'], capture_output=True, text=True)

    interfaces = [
        line.split()[0]
        for line in result.stdout.splitlines()
        if line.strip() and line.split()[0].startswith(name_starts_with)
    ]

    if interfaces:
        host_iface = interfaces[-1]
        print(f'[green]Detected host USB interface: {host_iface}[/]')
        return host_iface
    else:
        print('[red]Failed to detect host USB interface[/]')
        return None


def remove_all_adb_reverse_channels() -> None:
    print('[yellow]Removing all adb reverse channels ...[/]')
    result = sh.run(['adb', 'reverse', '--remove-all'])
    if result.returncode == 0:
        print('[green]Removed all adb reverse channels[/]')
    else:
        print('[red]Failed to remove all adb reverse channels[/]')
