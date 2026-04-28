{ config, inputs, ... }:
{
  configurations.nixos.tethys.module = {
    imports = (
      with config.flake.modules.nixos;
      [
        fs
        base
        hardware
        systemd-boot
        desktop
        cosmic
        btrfs
        keanu
        swapfile
        home-manager
      ]
    )
    ++ [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./_hardware-configuration.nix
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "tethys";

    services.logrotate.checkConfig = false;

    system.stateVersion = "23.05";
  };
}
