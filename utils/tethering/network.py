import subprocess as sh

from rich import print


def set_client_wifi(*, enable: bool) -> None:
    result = sh.run(['adb', 'shell', 'svc', 'wifi', 'enable' if enable else 'disable'])
    state = 'on' if enable else 'off'
    if result.returncode == 0:
        print(f"[green]Turned {state} client's WiFi[/]")
    else:
        print(f"[red]Failed to turn {state} client's WiFi[/]")


def detect_host_interface(*, name_starts_with: str) -> str:
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
        raise RuntimeError


def setup_host_ip(host_iface: str, network_prefix: str = '10.77.0') -> bool:
    print('[yellow]Setting up host IP address ...[/]')
    host_ip = f'{network_prefix}.1'
    host_addr = f'{host_ip}/24'

    # Flush, add address, and bring interface up
    flush_result = sh.run(['sudo', 'ip', 'addr', 'flush', 'dev', host_iface])
    add_result = sh.run(['sudo', 'ip', 'addr', 'add', host_addr, 'dev', host_iface])
    up_result = sh.run(['sudo', 'ip', 'link', 'set', host_iface, 'up'])

    if flush_result.returncode == 0 and add_result.returncode == 0 and up_result.returncode == 0:
        print(f'[green]Added IP address {host_addr} to interface {host_iface}[/]')
        sh.run(['ip', '-4', 'addr', 'show', 'dev', host_iface])
        return True
    else:
        print(f'[red]Failed to add IP address {host_addr} to interface {host_iface}[/]')
        raise RuntimeError
