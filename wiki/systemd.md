# Why systemd boot up slow?

1. check 'systemd-analyze critical-chain' if anything is waiting?
2. check 'systemctl list-jobs' if anything is stuck?
3. my last case is:
    ```
    JOB UNIT                                 TYPE  STATE
    2   multi-user.target                    start waiting
    137 docker.service                       start waiting
    1   graphical.target                     start waiting
    139 network-online.target                start waiting
    140 systemd-networkd-wait-online.service start running

    5 jobs listed.
    ```
    so job 140 systemd-networkd-wait-online.service is still long running
4. just tell systemd don't wait for this job by running:
    `sudo systemctl mask systemd-networkd-wait-online.service`
5. restart wsl, and the boot up time down to 5 secs or below, and docker.service is running normally
