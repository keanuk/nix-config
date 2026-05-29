{ config, inputs, ... }:
let
  sopsModule = config.flake.modules.nixos.sops;
in
{
  flake.modules.nixos.hardware =
    { pkgs, ... }:
    {
      imports = [ sopsModule ];

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

      system.autoUpgrade = {
        enable = true;
        allowReboot = false;
        flake = inputs.self.outPath;
        dates = "02:00";
        randomizedDelaySec = "45min";
      };
    };
}
