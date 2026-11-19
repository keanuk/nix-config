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
  configurations.nixos-stable.bucaccio = {
    isVps = true;
    deploy = {
      hostname = "vps.bucaccio.com";
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
      networking.hostName = "bucaccio";
      system.stateVersion = "25.11";

      staticWebsite = {
        domain = "bucaccio.com";
        webRoot = "/var/www/bucaccio";
        # Unprivileged CI deploy key for this site's GitHub Actions workflow.
        deployAuthorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDS5rawgaqa78S0s07aGlWgvHrVzb3QzUocqq51u0od3 github-action-bucaccio"
        ];
      };
    };
  };
}
