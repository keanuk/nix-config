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
    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager-stable.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    # Host-specific hardware
    ./disko-configuration.nix
    ./hardware-configuration.nix

    # Base configuration
    ../../_mixins/base
    ../../_mixins/base/vps.nix

    # User configuration
    ../../_mixins/user/keanu

    # Home Manager
    (mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../../home/vps/bucaccio/keanu.nix;
    })
  ];

  boot.loader = {
    grub = {
      enable = true;
      devices = [ "/dev/sda" ];
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    efi.canTouchEfiVariables = lib.mkForce false;
  };

  networking.hostName = "bucaccio";

  services.nginx = {
    enable = true;
    virtualHosts."bucaccio.com" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/bucaccio";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "keanu@kerr.us";
  };

  systemd.tmpfiles.rules = [
    "d /var/www/bucaccio 0755 keanu users -"
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  system.stateVersion = "25.11";
}
