{ config, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    hetzner-vps
    static-website
    keanu
    home-manager-stable
    ;
in
{
  configurations.nixos-stable.love-alaya = {
    isVps = true;
    deploy = {
      hostname = "love-alaya.com";
      sshUser = "keanu";
    };
    module = {
      imports = [
        base
        hetzner-vps
        static-website
        keanu
        home-manager-stable
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
