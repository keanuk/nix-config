{ config, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    vps-grub
    static-website
    keanu
    home-manager-stable
    ;
in
{
  configurations.nixos-stable.bucaccio = {
    isVps = true;
    deploy = {
      hostname = "vps.bucaccio.com";
      sshUser = "keanu";
    };
    module = {
      imports = [
        base
        vps-grub
        static-website
        keanu
        home-manager-stable
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
