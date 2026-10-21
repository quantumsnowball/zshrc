import subprocess as sh

from rich import print


def allow(host_iface: str, *, comment: str) -> bool:
    print('[yellow]Setting up firewall rules ...[/]')
    result = sh.run(['sudo', 'ufw', 'allow', 'in', 'on', host_iface, 'comment', comment])
    if result.returncode == 0:
        print(f'[green]Allowed {host_iface} in firewall rules[/]')
        return True

    print(f'[red]Failed to allow {host_iface} in firewall rules[/]')
    raise RuntimeError
