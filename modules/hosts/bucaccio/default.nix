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

      # CI deploy key for this site's GitHub Actions workflow, scoped to this host only.
      users.users.keanu.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDS5rawgaqa78S0s07aGlWgvHrVzb3QzUocqq51u0od3 github-action-bucaccio"
      ];

      staticWebsite = {
        domain = "bucaccio.com";
        webRoot = "/var/www/bucaccio";
      };
    };
  };
}
