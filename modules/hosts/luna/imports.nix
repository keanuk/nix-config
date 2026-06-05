{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    hardware
    lanzaboote
    laptop
    desktop
    gnome
    btrfs
    ollama
    keanu
    fs
    swapfile
    home-manager
    cellular
    oled
    ;
in
{
  configurations.nixos.luna.module =
    { ... }:
    {
      imports = [
        base
        hardware
        lanzaboote
        laptop
        desktop
        gnome
        btrfs
        ollama
        keanu
        fs
        swapfile
        home-manager
        cellular
        oled
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
        ./_disko-btrfs.nix
        ./_hardware-configuration.nix
      ];

      # Mount ursa's NFS share the same way the other laptops do.
      fileSystems."/mnt/data" = {
        device = "beehive.local:/data";
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

      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "luna";

      system.stateVersion = "26.11";
    };
}
