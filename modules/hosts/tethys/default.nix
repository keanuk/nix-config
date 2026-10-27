{ config, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    hardware
    intel
    systemd-boot
    desktop
    niri
    noctalia
    btrfs
    keanu
    swapfile
    fs
    home-manager
    ;
in
{
  configurations.nixos.tethys.module = {
    imports = [
      base
      hardware
      intel
      systemd-boot
      desktop
      niri
      noctalia
      btrfs
      keanu
      swapfile
      fs
      home-manager
      ./_hardware-configuration.nix
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "tethys";

    # Workaround: logrotate's config check fails during build on this host.
    # Status: active workaround (no upstream issue recorded)
    # Last-checked: 2026-08-22
    # Removal condition: retry enabling the check after nixpkgs bumps; remove when it passes.
    services.logrotate.checkConfig = false;

    system.stateVersion = "23.05";
  };
}
