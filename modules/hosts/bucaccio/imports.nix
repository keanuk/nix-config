{ config, ... }:
{
  configurations.nixos-stable.bucaccio = {
    isVps = true;
    deploy = {
      hostname = "vps.bucaccio.com";
      sshUser = "keanu";
    };
    module = {
      imports =
        (with config.flake.modules.nixos; [
          base
          vps-grub
          vps-website
          keanu
          home-manager-stable
        ])
        ++ [
          ./_hardware-configuration.nix
          ./_disko-configuration.nix
        ];

      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "bucaccio";
      system.stateVersion = "25.11";

      staticWebsite = {
        domain = "bucaccio.com";
        webRoot = "/var/www/bucaccio";
      };
    };
  };
}
