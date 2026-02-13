{
  inputs,
  outputs,
  mkHomeManagerHost,
  ...
}:
{
  imports = [
    # Flake inputs
    inputs.wsl.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    # Host-specific hardware
    ./hardware-configuration.nix

    # Base configuration (WSL-specific)
    ../_mixins/base/wsl.nix

    # User configuration
    ../_mixins/user/keanu

    # Home Manager
    (mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../home/mars/keanu.nix;
    })
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "mars";

  system.stateVersion = "25.11";
}
