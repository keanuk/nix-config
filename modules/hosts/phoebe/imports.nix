{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    amd
    hardware
    lanzaboote
    laptop
    desktop
    gnome
    niri
    noctalia
    btrfs
    ollama
    ollama-full
    keanu
    home-manager
    ;
in
{
  configurations.nixos.phoebe.module =
    { lib, ... }:
    {
      imports = [
        base
        amd
        hardware
        lanzaboote
        laptop
        desktop
        gnome
        niri
        noctalia
        btrfs
        ollama
        ollama-full
        keanu
        home-manager
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
        ./_hardware-configuration.nix
        ./_disko-btrfs.nix
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
      networking.hostName = "phoebe";

      services.ollama.rocmOverrideGfx = lib.mkForce "11.0.2";

      system.stateVersion = "25.11";
    };
}
