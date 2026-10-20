import subprocess

from rich import print


def main() -> str | None:
    # kill adb server
    subprocess.run(['adb', 'kill-server'])

    # fetch adb device list and look for authorized devices lines
    result = subprocess.run(['adb', 'devices'], stdout=subprocess.PIPE, text=True)
    devices = [
        line.split()[0]
        for line in result.stdout.splitlines()
        if line.strip() and line.endswith('\tdevice')
    ]

    # invalid result
    if len(devices) == 0:
        print('[red]Error: No authorized adb device connected[/]')
        return None
    elif len(devices) > 1:
        print('[red]Error: Multiple adb devices connected[/]')
        return None

    # valid result
    print(f'[green]Active connected device: {devices[0]}[/]')
    return devices[0]


if __name__ == '__main__':
    main()
