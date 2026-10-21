import functools
from time import sleep
from typing import Any, Callable, cast

from rich import print


# iif decorator
def exec[T](task: Callable[[], T]) -> T:
    return task()


# task
def task[F: Callable[..., Any]](
    desc: str,
    *,
    retry: int = 5,
    halt: bool = False,
    delay: float = 1.0,
) -> Callable[[F], F]:
    # decorator
    def decorator(f: F) -> F:
        # wrapper
        @functools.wraps(f)
        def wrapper(*args: Any, **kwargs: Any) -> Any:
            # intro message
            print(f'[yellow]Task: {desc} ...[/]')

            # retry loop
            for i in range(1, retry + 1):
                try:
                    # main logic here
                    # to fail and retry, raise any exception
                    result = f(*args, **kwargs)

                    # if no exception, succeed and break
                    print(f'[green]Success: {desc}[/]')
                    return result

                # on fail, will auto retry
                except Exception as e:
                    # max attempt reached, breaking retry loop
                    if i >= retry:
                        # fail message
                        print(f'[red]Fail: {desc}[/]')
                        # halt is turn on, fail will cause the main program to be terminated
                        if halt:
                            raise RuntimeError(f'Task failed permanently') from e
                        # break the retry loop
                        break

                    # show retry status
                    print(f'[yellow]Task: attempt {i}/{retry} failed, retrying ...[/]')

                    # delay before retry again
                    sleep(delay)
        #
        return cast(F, wrapper)
    #
    return decorator
