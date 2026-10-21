import subprocess as sh
import threading
from pathlib import Path
from time import sleep

from rich import print

DNSMASQ_PID_PATH = Path('/tmp/tethering_dnsmasq.pid')
DNSMASQ_LEASEFILE_PATH = Path('/tmp/tethering_dnsmasq.leases')


def start_server(
    host_iface: str,
    network_prefix: str = '10.77.0',
    *,
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
        process = sh.Popen(cmd, stdout=sh.PIPE, stderr=sh.STDOUT, text=True, bufsize=1)

        def stream_logs() -> None:
            if process.stdout:
                for line in process.stdout:
                    print(f'[dim cyan]{line.strip()}[/]')
        threading.Thread(target=stream_logs, daemon=True).start()
        DNSMASQ_PID_PATH.write_text(str(process.pid))
        print(f'\n[green]Started temporary dnsmasq DHCP server (PID: {process.pid})[/]')
        return True
    except Exception as e:
        print(f'[red]Failed to start dnsmasq DHCP server: {e}[/]')
        raise RuntimeError


def assign_client_ip(*, iface: str = 'usb0', wait: int = 10) -> bool:
    print('[yellow]Setting up client IP address ...[/]')

    result = sh.run(['adb', 'shell', 'cmd', 'ethernet', 'set-ip-configuration', iface, 'dhcp'])
    if result.returncode == 0:
        print('[green]Made Android client request an IP address via DHCP[/]')
        sleep(wait)
        return True

    print('[red]Failed to make Android client request an IP address via DHCP[/]')
    sleep(wait)
    raise RuntimeError


def kill_server() -> None:
    path = DNSMASQ_PID_PATH
    if path.is_file():
        print('[yellow]Cleaning up any ad-hoc spawn dnsmasq DHCP process ...[/]')
        pid = path.read_text().strip()
        if pid:
            sh.run(['sudo', 'kill', pid], stdout=sh.DEVNULL, stderr=sh.DEVNULL)
        path.unlink()
        print('[green]Done clean up any ad-hoc spawn dnsmasq DHCP process[/]')
