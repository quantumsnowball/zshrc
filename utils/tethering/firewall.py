import subprocess as sh

from task import now, task


def allow(host_iface: str, *, comment: str) -> None:
    @now
    @task(f'allow [cyan]{host_iface}[/] in firewall rules', halt=True)
    def _() -> None:
        sh.run([
            'sudo', 'ufw', 'allow', 'in', 'on', host_iface, 'comment', comment,
        ], check=True)
