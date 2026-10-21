from adb import disable_android_usb_device
from device import main as device
from dhcp import cleanup_dnsmasq_dhcp_server
from network import set_client_wifi

from utils import exit_on_runtime_error


@exit_on_runtime_error
def main() -> None:
    # ensure only one device connected
    if not device():
        return

    # toggle back on client's WiFi
    set_client_wifi(enable=True)

    # reset usb functions on android side
    disable_android_usb_device()

    # clean up any ad-hoc spawn dnsmasq dhcp leftover
    cleanup_dnsmasq_dhcp_server()


if __name__ == '__main__':
    main()
