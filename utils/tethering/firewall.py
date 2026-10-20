import subprocess as sh

from rich import print


def firewall_allow_interface(host_iface: str) -> bool:
    print('[yellow]Setting up firewall rules ...[/]')
    result = sh.run(['sudo', 'ufw', 'allow', 'in', 'on', host_iface, 'comment', 'tethering-s7'])
    if result.returncode == 0:
        print(f'[green]Allowed {host_iface} in firewall rules[/]')
        return True
    else:
        print(f'[red]Failed to allow {host_iface} in firewall rules[/]')
        return False
