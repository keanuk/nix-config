{ config, ... }:
{
  configurations.nixos-stable.emilyvansant = {
    isVps = true;
    deploy = {
      hostname = "vps.emilyvansant.com";
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
      networking.hostName = "emilyvansant";
      system.stateVersion = "25.11";

      staticWebsite = {
        domain = "emilyvansant.com";
        webRoot = "/var/www/emilyvansant";
      };
    };
  };
}
