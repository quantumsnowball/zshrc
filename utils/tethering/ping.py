import subprocess as sh

from dhcp import DNSMASQ_LEASEFILE_PATH
from rich import print


def ping_from_client_to(host_ip: str, client_iface: str | None = None, *, count: int = 5) -> bool:
    print('[yellow]Testing network connectivity from client side ...[/]')
    cmd = ['adb', 'shell', 'ping', '-c', str(count)]
    if client_iface is not None:
        cmd += ['-I', client_iface, ]
    cmd += [host_ip, ]
    result = sh.run(cmd)
    if result.returncode == 0:
        print('[green]Client passed the ping test[/]')
        return True
    else:
        print('[red]Client failed the ping test[/]')
        return False


def ping_from_host_to(client_ip: str, host_iface: str, *, count: int = 5) -> bool:
    result = sh.run(['ping', '-c', str(count), '-I', host_iface, client_ip])
    if result.returncode == 0:
        print('[green]Host passed the ping test[/]')
        return True
    else:
        print('[red]Host failed the ping test[/]')
        return False


def ping_from_host(host_iface: str, *, count: int = 5) -> bool:
    print('[yellow]Testing network connectivity from host side ...[/]')

    client_ip = None
    if DNSMASQ_LEASEFILE_PATH.is_file():
        lines = [line.strip() for line in DNSMASQ_LEASEFILE_PATH.read_text().splitlines() if line.strip()]
        if lines:
            # Last line contains the latest lease, field index 2 is usually the IP address
            parts = lines[-1].split()
            if len(parts) >= 3:
                client_ip = parts[2]

    if not client_ip:
        print('[red]Failed to find client IP from dnsmasq lease file[/]')
        return False

    result = ping_from_host_to(client_ip, host_iface, count=count)
    return result
