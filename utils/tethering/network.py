import subprocess as sh

from rich import print
from task import now, task


def set_client_wifi(*, enable: bool) -> None:
    state = 'on' if enable else 'off'

    @now
    @task(f"turn {state} client's WiFi")
    def _() -> None:
        if sh.run(['adb', 'shell', 'svc', 'wifi', 'enable' if enable else 'disable']).returncode != 0:
            raise RuntimeError


def detect_host_iface(*, name_starts_with: str) -> str:
    @task('detect host USB interface', halt=True)
    def f() -> str:
        result = sh.run(['ip', '-br', 'link', 'show'], capture_output=True, text=True)
        host_iface = [
            line.split()[0]
            for line in result.stdout.splitlines()
            if line.strip() and line.split()[0].startswith(name_starts_with)
        ][-1]
        print(f'[green]Detected host USB interface: [cyan]{host_iface}[/]')
        return host_iface
    #
    return f()


def detect_host_ip(host_iface: str) -> str:
    @task(f'detect host IP on interface {host_iface}', halt=True)
    def f() -> str:
        result = sh.run(['ip', '-4', 'addr', 'show', 'dev', host_iface], capture_output=True, text=True)
        for line in result.stdout.splitlines():
            line = line.strip()
            if line.startswith('inet '):
                # Example line: "inet 192.168.42.129/24 brd 192.168.42.255 scope global rndis0"
                parts = line.split()
                if len(parts) >= 2:
                    ip_cidr = parts[1]
                    ip_addr = ip_cidr.split('/')[0]
                    print(f'[green]Detected IP [cyan]{ip_addr}[/] on interface {host_iface}[/]')
                    return ip_addr
        #
        raise RuntimeError
    #
    return f()


def assign_host_ip(host_iface: str, network_prefix: str = '10.77.0') -> None:
    host_ip = f'{network_prefix}.1'
    host_addr = f'{host_ip}/24'

    @now
    @task(f'setup host IP address {host_ip} on interface {host_iface}', halt=True)
    def _() -> None:
        flush_result = sh.run(['sudo', 'ip', 'addr', 'flush', 'dev', host_iface])
        add_result = sh.run(['sudo', 'ip', 'addr', 'add', host_addr, 'dev', host_iface])
        up_result = sh.run(['sudo', 'ip', 'link', 'set', host_iface, 'up'])

        if flush_result.returncode == 0 and add_result.returncode == 0 and up_result.returncode == 0:
            sh.run(['ip', '-4', 'addr', 'show', 'dev', host_iface])
            return
        #
        raise RuntimeError


def remove_host_iface_default_route(host_iface: str) -> None:
    @now
    @task(f'remove default route for {host_iface}', halt=True)
    def _() -> None:
        result = sh.run(['sudo', 'ip', 'route', 'del', 'default', 'dev', host_iface], stderr=sh.DEVNULL)
        if result.returncode != 0:
            raise RuntimeError
