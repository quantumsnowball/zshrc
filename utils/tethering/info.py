import subprocess

from rich import print

from utils import exit_on_runtime_error


@exit_on_runtime_error
def main() -> None:
    print('[bold cyan]Host IP address status:[/]')
    subprocess.run(['ip', '-4', 'addr', 'show'])

    print('\n[bold cyan]Client IP address status:[/]')
    res = subprocess.run(['adb', 'shell', 'ip', '-4', 'addr', 'show', 'dev', 'usb0'])
    if res.returncode != 0:
        subprocess.run(['adb', 'shell', 'ip', '-4', 'addr', 'show', 'dev', 'rndis0'])


if __name__ == '__main__':
    main()
