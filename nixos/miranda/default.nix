{
  inputs,
  outputs,
  mkHomeManagerHost,
  ...
}:
{
  imports = [
    # Flake inputs
    inputs.home-manager.nixosModules.home-manager

    # Hardware support
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # Host-specific hardware
    ./hardware-configuration.nix
    ./disko-configuration.nix

    # Base configuration
    ../_mixins/base
    ../_mixins/base/hardware.nix
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
    (mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../home/miranda/keanu.nix;
    })
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "miranda";

  system.stateVersion = "25.05";
}
