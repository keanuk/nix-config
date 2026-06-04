{
  # Enables ModemManager to control built-in cellular modems (Quectel
  # RM520N-GL on the X1 Carbon Gen 13, or other MBIM/QMI devices).
  # NetworkManager (already on via the `desktop` role) will surface the
  # modem as a connection once a bearer is created with `mmcli` or via
  # nm-connection-editor.
  flake.modules.nixos.cellular =
    {
      pkgs,
      ...
    }:
    {
      networking.modemmanager = {
        enable = true;

        # The Quectel RM520N-GL ships carrier-locked: US 5G NR band n77
        # (C-Band) is gated behind an FCC unlock certificate. Drop the
        # JSON that Quectel distributes in their Windows driver package
        # (Quectel_FCC_Unlock.json) at the path below; ModemManager
        # applies it automatically when the modem enumerates.
        fccUnlockScripts = [
          {
            id = "2c7c:0800";
            path = "/var/lib/cellular/fcc-unlock/2c7c:0800.json";
          }
        ];
      };

      # Cellular modems ship with proprietary firmware (Quectel, Fibocom)
      # that is not in the default linux-firmware package.
      hardware.enableRedistributableFirmware = true;

      # Directory for the FCC unlock data file referenced above. The file
      # itself is provided out-of-band (see the imports.nix comment for
      # luna) so it survives rebuilds without leaking into the Nix store.
      systemd.tmpfiles.rules = [
        "d /var/lib/cellular/fcc-unlock 0755 root root -"
      ];

      # Hand cdc_mbim / cdc_wwan / qmi_wwan devices to ModemManager instead
      # of letting cdc_ether claim them as plain network interfaces.
      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{ID_USB_DRIVER}=="cdc_mbim", ENV{ID_MM_DEVICE_PROCESS}="1"
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{ID_USB_DRIVER}=="qmi_wwan", ENV{ID_MM_DEVICE_PROCESS}="1"
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{ID_USB_DRIVER}=="cdc_wwan", ENV{ID_MM_DEVICE_PROCESS}="1"
      '';

      environment.systemPackages = with pkgs; [
        modemmanager
        libqmi
        libmbim
        mobile-broadband-provider-info
      ];
    };
}
