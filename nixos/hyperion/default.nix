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
    inputs.nixos-hardware.nixosModules.hp-elitebook-845g8

    # Host-specific hardware
    ./hardware-configuration.nix

    # Base configuration
    ../_mixins/base
    ../_mixins/base/lanzaboote.nix
    ../_mixins/base/laptop.nix

    # Desktop environment
    ../_mixins/desktop
    ../_mixins/desktop/pantheon

    # Services
    ../_mixins/services/btrfs

    # User configuration
    ../_mixins/user/keanu
    ../_mixins/user/kimmy

    # TODO: change during next reinstall
    ../_mixins/base/swapfile.nix
    ../_mixins/base/fs.nix

    # Home Manager
    (lib.mkHomeManagerHost {
      inherit inputs outputs;
      users = {
        keanu = ../../home/hyperion/keanu.nix;
        kimmy = ../../home/hyperion/kimmy.nix;
      };
    })
  ];

  networking.hostName = "hyperion";

  i18n = {
    defaultLocale = lib.mkForce "en_US.UTF-8";
    extraLocaleSettings = lib.mkForce {
      LC_ALL = "en_US.UTF-8";
    };
  };

  system.stateVersion = "23.05";
}
