{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    hardware
    lanzaboote
    laptop
    desktop
    niri
    noctalia
    btrfs
    keanu
    kimmy
    swapfile
    fs
    home-manager
    ;
in
{
  configurations.nixos.hyperion.module =
    { lib, ... }:
    {
      imports = [
        base
        hardware
        lanzaboote
        laptop
        desktop
        niri
        noctalia
        btrfs
        keanu
        kimmy
        swapfile
        fs
        home-manager
        inputs.nixos-hardware.nixosModules.hp-elitebook-845g8
        ./_hardware-configuration.nix
      ];

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
      networking.hostName = "hyperion";

      i18n = {
        defaultLocale = lib.mkForce "en_US.UTF-8";
        extraLocaleSettings = lib.mkForce {
          LC_ALL = "en_US.UTF-8";
        };
      };

      system.stateVersion = "23.05";
    };
}
