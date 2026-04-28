{ config, inputs, ... }:
{
  configurations.nixos.earth.module = {
    imports = (
      with config.flake.modules.nixos;
      [
        base
        hardware
        pc
        rtw88-fix
        systemd-boot
        desktop
        cosmic
        btrfs
        ollama
        keanu
        home-manager
      ]
    )
    ++ [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./_disko-configuration.nix
      ./_hardware-configuration.nix
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "earth";
    system.stateVersion = "23.11";
  };
}
