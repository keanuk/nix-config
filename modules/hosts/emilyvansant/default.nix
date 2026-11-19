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
  configurations.nixos-stable.emilyvansant = {
    isVps = true;
    deploy = {
      hostname = "vps.emilyvansant.com";
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
      networking.hostName = "emilyvansant";
      system.stateVersion = "25.11";

      staticWebsite = {
        domain = "emilyvansant.com";
        webRoot = "/var/www/emilyvansant";
        # Unprivileged CI deploy key for this site's GitHub Actions workflow.
        deployAuthorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0XU5XdS3NQxo6m8CkJHWKLGE8Dc0WgBi1hmfy4hqnI github-action-emilyvansant"
        ];
      };
    };
  };
}
