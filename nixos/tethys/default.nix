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
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # Host-specific hardware
    ./hardware-configuration.nix

    # Base configuration
    ../_mixins/base/fs.nix
    ../_mixins/base
    ../_mixins/base/hardware.nix
    ../_mixins/base/systemd-boot.nix

    # Desktop environment
    ../_mixins/desktop
    ../_mixins/desktop/cosmic

    # Services
    ../_mixins/services/btrfs

    # User configuration
    ../_mixins/user/keanu

    # TODO: Change during next reinstall
    ../_mixins/base/swapfile.nix

    # Home Manager
    (mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../home/tethys/keanu.nix;
    })
  ];

  networking.hostName = "tethys";

  services.logrotate.checkConfig = false;

  system.stateVersion = "23.05";
}
