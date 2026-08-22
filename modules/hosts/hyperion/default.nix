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
    nfs-data
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
        nfs-data
        inputs.nixos-hardware.nixosModules.hp-elitebook-845g8
        ./_hardware-configuration.nix
      ];

      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "hyperion";

      i18n = {
        defaultLocale = lib.mkForce "en_US.UTF-8";
        extraLocaleSettings = lib.mkForce {
          LC_ALL = "en_US.UTF-8";
        };
      };

      boot.initrd = {
        systemd.tpm2.enable = true;
        luks.devices."cryptroot".crypttabExtraOpts = [
          "tpm2-device=auto"
          "tpm2-pcrs=7"
        ];
      };

      system.stateVersion = "23.05";
    };
}
