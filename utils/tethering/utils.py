import subprocess as sh
from functools import wraps
from typing import Any, Callable, TypeVar

from rich import print

Wrapped = TypeVar('Wrapped', bound=Callable[..., Any])


def exit_on_runtime_error(wrapped: Wrapped) -> Wrapped:
    @wraps(wrapped)
    def wrapper(*args: Any, **kwargs: Any) -> Any:
        try:
            return wrapped(*args, **kwargs)
        except RuntimeError:
            print('[red]RuntimeError, stopped[/]')
            raise SystemExit(1)
    return wrapper  # type: ignore


def touch_sudo() -> bool:
    res = sh.run(['sudo', '-v'])
    if res.returncode != 0:
        print('[red]Failed to get root permission[/]')
        raise RuntimeError
    return True


def usb_connection_ready() -> None:
    print('[green]Your USB network is ready![/]')
