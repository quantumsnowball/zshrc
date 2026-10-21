import dhcp
import network
from adb import disable_android_usb_device
from device import main as device

from utils import exit_on_runtime_error


@exit_on_runtime_error
def main() -> None:
    # ensure only one device connected
    device()
    # toggle back on client's WiFi
    network.set_client_wifi(enable=True)
    # reset usb functions on android side
    disable_android_usb_device()
    # clean up any ad-hoc spawn dnsmasq dhcp leftover
    dhcp.kill_server()


if __name__ == '__main__':
    main()
