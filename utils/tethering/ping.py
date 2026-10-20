import subprocess as sh

from rich import print


def ping_from_client_to(host_ip: str, *, count: int = 5) -> bool:
    print('[yellow]Testing network connectivity from client side ...[/]')
    result = sh.run(['adb', 'shell', 'ping', '-c', str(count), '-I', 'usb0', host_ip])
    if result.returncode == 0:
        print('[green]Client passed the ping test[/]')
        return True
    else:
        print('[red]Client failed the ping test[/]')
        return False
