import subprocess as sh

from rich import print
from task import now, task

import utils


def ensure_single_connection() -> None:
    @now
    @task('ensure single device connection', halt=True, retry=False)
    def _() -> None:
        # kill adb server
        sh.run(['adb', 'kill-server'])

        # fetch adb device list and look for authorized devices lines
        result = sh.run(['adb', 'devices'], stdout=sh.PIPE, text=True)
        devices = [
            line.split()[0]
            for line in result.stdout.splitlines()
            if line.strip() and line.endswith('\tdevice')
        ]

        # invalid result
        if len(devices) == 0:
            print('[red]Error: no authorized adb device connected[/]')
            raise RuntimeError
        if len(devices) > 1:
            print('[red]Error: multiple adb devices connected[/]')
            raise RuntimeError


@utils.exit_on_runtime_error
def main() -> None:
    ensure_single_connection()


if __name__ == '__main__':
    main()
