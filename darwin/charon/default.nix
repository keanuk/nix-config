{
  inputs,
  outputs,
  mkHomeManagerHost,
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

    # User configuration
    ../_mixins/user/keanu

    # Home Manager
    (mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../home/charon/keanu.nix;
    })
  ];

  networking.hostName = "charon";

  nixpkgs.hostPlatform = "x86_64-darwin";

  system.stateVersion = 4;
}
