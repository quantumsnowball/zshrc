#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#   "rich",
# ]
# ///

import asyncio
import random
from typing import Callable

from rich.live import Live
from rich.table import Table

Renderer = Callable[[], Table]


class Repo:
    NAMES = (
        'zshrc',
        'nvim',
        'tmux',
        'workspace',
        'workspace-private',
    )

    def __init__(self, name: str, *, host: str) -> None:
        self.name = name
        self.host = host
        self.state = ''

    async def pull(self, live: Live, renderer: Renderer) -> None:
        # Set initial state and update UI
        self.state = '[yellow]PULLING[/yellow]'
        live.update(renderer())

        # Construct the target git pull command
        target_path = f'~/.config/{self.name}'
        git_cmd = f'git -C {target_path} pull --rebase --autostash'

        try:
            # Execute SSH asynchronously
            process = await asyncio.create_subprocess_exec(
                'ssh',
                '-A',                           # SSH agent forwarding, use the the current machine's ssh key for remote auth
                '-o', 'ConnectTimeout=10',      # Fast fail if device is offline
                '-o', 'BatchMode=yes',          # Prevent hanging on password prompts
                self.host,
                git_cmd,
                stdout=asyncio.subprocess.DEVNULL,
                stderr=asyncio.subprocess.DEVNULL,
            )

            # Wait for process to complete
            await process.wait()

            # Update state based on SSH return code
            if process.returncode == 0:
                self.state = '[bold green]SUCCESS[/bold green]'
            else:
                self.state = '[bold red]FAILED[/bold red]'

        except asyncio.CancelledError:
            self.state = '[dim white]CANCELLED[/dim white]'
            raise
        except Exception:
            self.state = '[bold red]ERROR[/bold red]'
        finally:
            # Re-render the table with final status
            live.update(renderer())


class Host:
    NAMES = (
        's7',
        'a9',
        'a56',
    )

    def __init__(self, name: str) -> None:
        self.name = name
        self.repos = [Repo(name, host=self.name) for name in Repo.NAMES]

    async def pull(self, live: Live, renderer: Renderer) -> None:
        tasks = [repo.pull(live, renderer) for repo in self.repos]
        await asyncio.gather(*tasks)


class Manager:
    def __init__(self) -> None:
        self.hosts = [Host(name) for name in Host.NAMES]

    def renderer(self) -> Table:
        table = Table(title='SSH Host Dot Repos Manager')
        table.add_column('Host', style='bold white', width=20)
        for host_name in Host.NAMES:
            table.add_column(host_name, style='bold cyan', width=10)
        for i, repo_name in enumerate(Repo.NAMES):
            states = [host.repos[i].state for host in self.hosts]
            table.add_row(repo_name, *states)
        return table

    async def pull(self) -> None:
        with Live(self.renderer(), refresh_per_second=10) as live:
            tasks = [host.pull(live, self.renderer) for host in self.hosts]
            await asyncio.gather(*tasks)


async def main() -> None:
    manager = Manager()
    await manager.pull()


if __name__ == '__main__':
    asyncio.run(main())
