import subprocess as sh

from rich import print

from utils import exit_on_runtime_error


def show_host_ip_status() -> None:
    print('[bold cyan]Host IP address status:[/]')
    sh.run(['ip', '-4', 'addr', 'show'])


def show_client_ip_status() -> None:
    print('\n[bold cyan]Client IP address status:[/]')
    result = sh.run(['adb', 'shell', 'ip', '-4', 'addr', 'show', 'dev', 'usb0'])
    if result.returncode != 0:
        sh.run(['adb', 'shell', 'ip', '-4', 'addr', 'show', 'dev', 'rndis0'])


@exit_on_runtime_error
def main() -> None:
    # host
    show_host_ip_status()
    # client
    show_client_ip_status()


if __name__ == '__main__':
    main()
