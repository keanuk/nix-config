{
  inputs,
  outputs,
  mkHomeManagerHost,
  ...
}:
{
  imports = [
    # Flake inputs
    inputs.home-manager-stable.nixosModules.home-manager

    # Host-specific hardware
    ./disko-configuration.nix
    ./hardware-configuration.nix

    # Base configuration
    ../../_mixins/base
    ../../_mixins/base/vps.nix

    # Static website
    (import ../../_mixins/services/static-website {
      domain = "bucaccio.com";
      webRoot = "/var/www/bucaccio";
    })

    # User configuration
    ../../_mixins/user/keanu

    # Home Manager
    (mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../../home/vps/bucaccio/keanu.nix;
    })
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "bucaccio";

  system.stateVersion = "25.11";
}
