{
  inputs,
  outputs,
  lib,
  ...
}:
{
  imports = [
    # Flake inputs
    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    # Hardware support
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # Host-specific hardware
    ./hardware-configuration.nix
    ./disko-configuration.nix

    # Base configuration
    ../_mixins/base
    ../_mixins/base/lanzaboote.nix
    ../_mixins/base/laptop.nix

    # Desktop environment
    ../_mixins/desktop
    ../_mixins/desktop/cosmic

    # Services
    ../_mixins/services/btrfs

    # User configuration
    ../_mixins/user/keanu

    # Home Manager
    (lib.mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../home/miranda/keanu.nix;
    })
  ];

  networking.hostName = "miranda";

  system.stateVersion = "25.05";
}
