{
  config,
  inputs,
  ...
}:
let
  inherit (config.flake.modules.nixos)
    base
    amd
    hardware
    lanzaboote
    pc
    rtw88-fix
    desktop
    niri
    noctalia
    btrfs
    ollama
    ollama-medium
    ollama-high
    keanu
    swapfile
    fs
    home-manager
    ;
in
{
  configurations.nixos.titan.module =
    { lib, ... }:
    {
      imports = [
        base
        amd
        hardware
        lanzaboote
        pc
        rtw88-fix
        desktop
        niri
        noctalia
        btrfs
        ollama
        ollama-medium
        ollama-high
        keanu
        swapfile
        fs
        home-manager
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        inputs.nixos-hardware.nixosModules.common-pc
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        ./_hardware-configuration.nix
      ];

      fileSystems."/mnt/data" = {
        device = "ursa:/data";
        fsType = "nfs";
        options = [
          "rw"
          "noatime"
          "_netdev"
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "x-systemd.mount-timeout=10"
          "x-systemd.requires=tailscaled.service"
          "nfsvers=4"
        ];
      };

      # The MSI Optix monitor exposes a broken 22 KiB "Optix Driver" USB storage
      # device (1462:3fa4). Every I/O to it fails with DID_ERROR, and SCSI error
      # handling on it stalls the final kernel shutdown by 1-2 minutes.
      # `i` (IGNORE_DEVICE) makes usb-storage never bind to it.
      boot.kernelParams = [ "usb-storage.quirks=1462:3fa4:i" ];

      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "titan";

      services.ollama.rocmOverrideGfx = lib.mkForce "10.3.0";

      boot.initrd = {
        systemd.tpm2.enable = true;
        luks.devices = {
          "cryptroot".crypttabExtraOpts = [
            "tpm2-device=auto"
            "tpm2-pcrs=7"
          ];
          "cryptroot2".crypttabExtraOpts = [
            "tpm2-device=auto"
            "tpm2-pcrs=7"
          ];
        };
      };

      system.stateVersion = "23.05";
    };
}
