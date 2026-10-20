import subprocess as sh

from rich import print


def touch_sudo() -> bool:
    res = sh.run(['sudo', '-v'])
    if res.returncode != 0:
        print('[red]Failed to get root permission[/]')
        return False
    return True


def remove_all_adb_reverse_channels() -> None:
    print('[yellow]Removing all adb reverse channels ...[/]')
    result = sh.run(['adb', 'reverse', '--remove-all'])
    if result.returncode == 0:
        print('[green]Removed all adb reverse channels[/]')
    else:
        print('[red]Failed to remove all adb reverse channels[/]')
