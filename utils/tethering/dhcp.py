import subprocess as sh
from pathlib import Path
from time import sleep

from disconnect import DNSMASQ_PID_PATH
from rich import print

DNSMASQ_LEASEFILE_PATH = Path('/tmp/tethering_dnsmasq.leases')


def start_dnsmasq_server(
    host_iface: str,
    *,
    network_prefix: str = '10.77.0',
    leasetime: str = '24h',
) -> bool:
    # note: ip addr through rtnetlink gives permissio error, so impossible to set fixed ip here

    print('[yellow]Starting temporary dnsmasq DHCP server ...[/]')
    host_ip = f'{network_prefix}.1'

    # Truncate lease file with sudo
    sh.run(['sudo', 'truncate', '-s', '0', str(DNSMASQ_LEASEFILE_PATH)])

    # Start dnsmasq in the background (equivalent to & in bash)
    cmd = [
        'sudo',
        'dnsmasq',
        '--no-daemon',
        '--log-dhcp',
        '--port=0',
        f'--dhcp-leasefile={DNSMASQ_LEASEFILE_PATH}',
        f'--interface={host_iface}',
        '--bind-interfaces',
        '--dhcp-authoritative',
        f'--dhcp-range={network_prefix}.2,{network_prefix}.254,255.255.255.0,{leasetime}',
        f'--dhcp-option=3,{host_ip}',
    ]

    try:
        # Popen runs the process asynchronously in the background
        process = sh.Popen(cmd)
        DNSMASQ_PID_PATH.write_text(str(process.pid))
        print(f'\n[green]Started temporary dnsmasq DHCP server (PID: {process.pid})[/]')
        return True
    except Exception as e:
        print(f'[red]Failed to start dnsmasq DHCP server: {e}[/]')
        return False


def setup_client_ip(*, iface: str = 'usb0', wait: int = 10) -> bool:
    print('[yellow]Setting up client IP address ...[/]')

    result = sh.run(['adb', 'shell', 'cmd', 'ethernet', 'set-ip-configuration', iface, 'dhcp'])
    if result.returncode == 0:
        print('[green]Made Android client request an IP address via DHCP[/]')
        sleep(wait)
        return True
    else:
        print('[red]Failed to make Android client request an IP address via DHCP[/]')
        sleep(wait)
        return False
