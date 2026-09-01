_: {
  flake.modules.nixos.hardware =
    { pkgs, ... }:
    {
      boot = {
        plymouth.enable = true;
        kernelPackages = pkgs.linuxPackages_latest;
        supportedFilesystems = [ "bcachefs" ];
      };

      hardware = {
        enableAllFirmware = true;
        enableRedistributableFirmware = true;
        ksm.enable = true;
      };

      services.fwupd.enable = true;

      environment.systemPackages = with pkgs; [
        acpid
        unstable.bcachefs-tools
        dmidecode
        hwdata
        linux-wifi-hotspot
        sbctl
        smartmontools
        snapper
        tpm2-tools
        tpm2-tss
        usbutils
      ];
    };
}
