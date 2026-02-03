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
    inputs.home-manager-stable.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    # Hardware support
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # Host-specific hardware
    ./disko-configuration.nix
    ./hardware-configuration.nix
    # TODO: re-enable when RAID issues are resolved
    # ./raid-configuration.nix

    # Base configuration
    ../_mixins/base/amd.nix
    ../_mixins/base
    ../_mixins/base/server.nix
    ../_mixins/base/systemd-boot.nix

    # Services
    ../_mixins/services/btrfs

    # User configuration
    ../_mixins/user/keanu

    # Home Manager
    (mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../home/beehive/keanu.nix;
    })
  ];

  networking.hostName = "beehive";

  system.stateVersion = "25.05";
}
