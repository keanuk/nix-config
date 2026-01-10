{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager-stable.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    ./disko-configuration.nix
    ./hardware-configuration.nix

    ../../_mixins/base
    ../../_mixins/base/vps.nix
    ../../_mixins/base/systemd-boot.nix

    ../../_mixins/user/keanu
  ];

  networking.hostName = "bucaccio";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../../home/vps/bucaccio/keanu.nix];
  };

  system.stateVersion = "25.11";

  services.nginx = {
    enable = true;
    virtualHosts."bucaccio.com" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/bucaccio.com";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "keanu@kerr.us";
  };

  systemd.tmpfiles.rules = [
    "d /var/www/bucaccio.com 0755 keanu users -"
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
