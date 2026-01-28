{
  inputs,
  outputs,
  mkHomeManagerHost,
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
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # Host-specific hardware
    ./disko-configuration.nix
    ./hardware-configuration.nix

    # Base configuration
    ../_mixins/base
    ../_mixins/base/pc.nix
    ../_mixins/base/systemd-boot.nix

    # Desktop environment
    ../_mixins/desktop
    ../_mixins/desktop/cosmic

    # Services
    ../_mixins/services/btrfs
    ../_mixins/services/ollama

    # User configuration
    ../_mixins/user/keanu

    # Home Manager
    (mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../home/earth/keanu.nix;
    })
  ];

  networking.hostName = "earth";

  system.stateVersion = "23.11";
}
