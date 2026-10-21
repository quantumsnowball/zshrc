import adb
import device
import dhcp
import network

import utils


@utils.exit_on_runtime_error
def main() -> None:
    # ensure only one device connected
    device.ensure_single_connection()
    # toggle back on client's WiFi
    network.set_client_wifi(enable=True)
    # reset usb functions on android side
    adb.disable_android_usb_device()
    # clean up any ad-hoc spawn dnsmasq dhcp leftover
    dhcp.kill_server()


if __name__ == '__main__':
    main()
