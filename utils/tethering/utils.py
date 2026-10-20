import subprocess as sh

from rich import print


def touch_sudo() -> bool:
    res = sh.run(['sudo', '-v'])
    if res.returncode != 0:
        print('[red]Failed to get root permission[/]')
        return False
    return True


def usb_connection_ready() -> None:
    print('[green]Your USB network is ready![/]')
