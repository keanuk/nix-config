{ config, ... }:
{
  configurations.nixos-stable.love-alaya = {
    isVps = true;
    deploy = {
      hostname = "love-alaya.com";
      sshUser = "keanu";
    };
    module = {
      imports = (
        with config.flake.modules.nixos;
        [
          base
          vps-grub
          vps-website
          user-keanu
          home-manager-stable
        ]
      )
      ++ [
        ./_hardware-configuration.nix
        ./_disko-configuration.nix
      ];

      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "love-alaya";
      system.stateVersion = "25.11";

      staticWebsite = {
        domain = "love-alaya.com";
        webRoot = "/var/www/love-alaya";
      };
    };
  };
}
