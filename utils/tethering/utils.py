import subprocess as sh
from functools import wraps
from typing import Any, Callable, TypeVar

from rich import print
from task import now, task

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


def acquire_sudo() -> None:
    @now
    @task('acquire root permission', retry=False, halt=True)
    def _() -> None:
        if sh.run(['sudo', '-v']).returncode != 0:
            raise RuntimeError


def tethering_connection_ready() -> None:
    print('[green]Your USB network is ready![/]')
