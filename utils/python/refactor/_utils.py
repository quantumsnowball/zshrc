import subprocess

from rich.console import Console

console = Console(highlight=False)


def ruff_isort(input: str) -> str:
    try:
        return subprocess.check_output(
            ['ruff', 'check', '--select', 'I', '--fix', '-'],
            input=input,
            stderr=subprocess.DEVNULL,
            text=True,
        )
    except subprocess.CalledProcessError:
        return input
    except Exception as e:
        console.print(f'[red]{e}[/]')
        return input
