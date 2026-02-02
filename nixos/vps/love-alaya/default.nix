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
      users.keanu = ../../../home/vps/love-alaya/keanu.nix;
    })
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    # devices is set automatically by disko based on EF02 partition
  };

  networking.hostName = "love-alaya";

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."love-alaya.com" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/love-alaya";
      # Handle both root domain and www
      serverAliases = [ "www.love-alaya.com" ];
      locations."/" = {
        tryFiles = "$uri $uri/ =404";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "keanu@kerr.us";
  };

  systemd.tmpfiles.rules = [
    "d /var/www/love-alaya 0755 keanu users -"
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  system.stateVersion = "25.11";
}
