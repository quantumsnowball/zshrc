import subprocess as sh

from dhcp import DNSMASQ_LEASEFILE_PATH
from task import now, task


def from_client_to_host_ip(host_ip: str, client_iface: str | None = None, *, count: int = 5) -> None:
    @now
    @task(f'ping from client to host ip {host_ip}', retry=False)
    def _() -> None:
        cmd = ['adb', 'shell', 'ping', '-c', str(count)]
        if client_iface is not None:
            cmd += ['-I', client_iface, ]
        cmd += [host_ip, ]
        if sh.run(cmd).returncode != 0:
            raise RuntimeError


def from_host_to_client_ip(client_ip: str, host_iface: str, *, count: int = 5) -> None:
    @now
    @task(f'ping from host to client ip {client_ip}', retry=False)
    def _() -> None:
        if sh.run(['ping', '-c', str(count), '-I', host_iface, client_ip]).returncode != 0:
            raise RuntimeError


def from_host(host_iface: str, *, count: int = 5) -> None:
    @task('find client IP from dnsmasq lease file')
    def f() -> str:
        client_ip = None
        if DNSMASQ_LEASEFILE_PATH.is_file():
            lines = [line.strip() for line in DNSMASQ_LEASEFILE_PATH.read_text().splitlines() if line.strip()]
            if lines:
                # Last line contains the latest lease, field index 2 is usually the IP address
                parts = lines[-1].split()
                if len(parts) >= 3:
                    client_ip = parts[2]
                    return client_ip
        raise RuntimeError
    #
    client_ip = f()
    from_host_to_client_ip(client_ip, host_iface, count=count)
