import asyncio
import os
from asyncio.subprocess import Process
from dataclasses import dataclass


@dataclass(slots=True)
class Result:
    host: str
    cmd: str
    process: Process
    stdout: bytes
    stderr: bytes

    @property
    def returncode(self) -> int:
        code = self.process.returncode
        return code if code is not None else -1

    @property
    def ok(self) -> bool:
        return self.returncode == 0

    @property
    def stdout_str(self) -> str:
        return self.stdout.decode().strip()

    @property
    def stderr_str(self) -> str:
        return self.stderr.decode().strip()


async def exec(
    *,
    host: str,
    cmd: str,
    agent_passthrough: bool = True,
    connect_timeout: int = 10,
    batch_mode: bool = True,
) -> Result:
    # args
    args = [
        'ssh',
        *(('-A',) if agent_passthrough else ()),
        '-o', f'ConnectTimeout={connect_timeout}',
        '-o', f"BatchMode={'yes' if batch_mode else 'no'}",
        host,
        cmd,
    ]
    # process
    process = await asyncio.create_subprocess_exec(
        *args,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
        env=os.environ,
    )
    # communicate
    stdout, stderr = await process.communicate()
    # result
    return Result(
        host=host,
        cmd=cmd,
        process=process,
        stdout=stdout,
        stderr=stderr,
    )
