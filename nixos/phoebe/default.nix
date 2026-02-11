{
  inputs,
  outputs,
  mkHomeManagerHost,
  lib,
  ...
}:
{
  imports = [
    # Flake inputs
    inputs.home-manager.nixosModules.home-manager

    # Hardware support
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5

    # Host-specific hardware
    ./hardware-configuration.nix
    ./disko-btrfs.nix

    # Base configuration
    ../_mixins/base
    ../_mixins/base/amd.nix
    ../_mixins/base/hardware.nix
    ../_mixins/base/lanzaboote.nix
    ../_mixins/base/laptop.nix

    # Desktop environment
    ../_mixins/desktop
    ../_mixins/desktop/pantheon

    # Services
    ../_mixins/services/btrfs
    ../_mixins/services/ollama

    # User configuration
    ../_mixins/user/keanu

    # Home Manager
    (mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../home/phoebe/keanu.nix;
    })
  ];

  networking.hostName = "phoebe";

  services.ollama.rocmOverrideGfx = lib.mkForce "11.0.2";

  system.stateVersion = "25.11";
}
