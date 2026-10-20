import subprocess as sh

from rich import print


def set_client_wifi(*, enable: bool) -> None:
    result = sh.run(['adb', 'shell', 'svc', 'wifi', 'enable' if enable else 'disable'])
    if result.returncode == 0:
        print("[green]Toggled back on client's WiFi[/]")
    else:
        print("[red]Failed to toggle back on client's WiFi[/]")
