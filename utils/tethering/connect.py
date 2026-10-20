import sys

from rich import print

from utils import foo


def main() -> None:
    print(f'[green]run connect()[/]')
    foo()
    print(sys.path)


if __name__ == '__main__':
    main()
