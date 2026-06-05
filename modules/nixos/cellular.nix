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

        # The Quectel RM520N-GL ships in FCC-locked state; the radio must
        # be explicitly enabled before it will transmit. Upstream
        # ModemManager ships a one-shot `mbimcli --quectel-set-radio-state=on`
        # script and installs symlinks for the Lenovo-rebadged USB IDs
        # (1eac:1001/1004/1007) pointing at it. Enabling it here is
        # equivalent to copying the file into /etc/ModemManager/fcc-unlock.d/.
        #
        # 1eac:1007 = Lenovo-shipped Quectel RM520N-GL (X1 Carbon Gen 13).
        # Confirm with `lsusb` after first boot; if the modem reports a
        # different VID:PID, add another entry pointing at the same script.
        fccUnlockScripts = [
          {
            id = "1eac:1007";
            path = "${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/1eac:1007";
          }
        ];
      };

      environment.systemPackages = with pkgs; [
        modemmanager
        libqmi
        libmbim
        mobile-broadband-provider-info
      ];
    };
}
