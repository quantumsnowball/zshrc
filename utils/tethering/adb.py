import subprocess as sh

from rich import print


def disable_android_usb_device() -> None:
    sh.run(['adb', 'shell', 'svc', 'usb', 'setFunctions', 'mtp'])
    link_res = sh.run(
        ['adb', 'shell', 'ip', '-br', 'link'], capture_output=True, text=True
    )
    link_output = link_res.stdout
    link_active = 'rndis0' in link_output or 'usb0' in link_output
    if not link_active:
        print('[green]Reset USB functions on android side[/]')
    else:
        print('[red]Failed to reset USB functions on android side[/]')
