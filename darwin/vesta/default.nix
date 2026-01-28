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
      users.keanu = ../../home/vesta/keanu.nix;
    })
  ];

  networking.hostName = "vesta";

  system.stateVersion = 4;
}
