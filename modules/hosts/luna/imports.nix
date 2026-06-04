{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    hardware
    lanzaboote
    laptop
    desktop
    cosmic
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
        cosmic
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
      ];

      # Quectel RM520N-GL FCC unlock: download Quectel_FCC_Unlock.json
      # from Quectel's Windows USB driver package and drop it at
      # /var/lib/cellular/fcc-unlock/2c7c:0800.json so ModemManager can
      # apply it on first boot.
      environment.etc."cellular/fcc-unlock-readme.md".text = ''
        Place the Quectel RM520N-GL FCC unlock JSON at:
          /var/lib/cellular/fcc-unlock/2c7c:0800.json
        Obtain it from Quectel's Windows driver bundle (Quectel_FCC_Unlock.json)
        or contact Quectel support for the matching certificate.
      '';

      # Mount beehive's NFS share the same way the other laptops do.
      # Swap to ursa.local once the migration is complete.
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

      system.stateVersion = "25.11";
    };
}
