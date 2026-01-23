{
  inputs,
  outputs,
  lib,
  ...
}:
{
  imports = [
    # Flake inputs
    inputs.home-manager.darwinModules.home-manager

    # Host-specific hardware
    ./hardware-configuration.nix

    # Base configuration
    ../_mixins/base
    ../_mixins/base/homebrew-aarch.nix

    # User configuration
    ../_mixins/user/keanu

    # Home Manager
    (lib.mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../home/salacia/keanu.nix;
    })
  ];

  networking.hostName = "salacia";

  homebrew.caskArgs.appdir = "/Volumes/SALACIA-EXT/Applications";

  system.stateVersion = 6;
}
