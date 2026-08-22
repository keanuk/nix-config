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
  configurations.nixos-stable.emilyvansant = {
    isVps = true;
    deploy = {
      hostname = "vps.emilyvansant.com";
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
      networking.hostName = "emilyvansant";
      system.stateVersion = "25.11";

      # CI deploy key for this site's GitHub Actions workflow, scoped to this host only.
      users.users.keanu.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0XU5XdS3NQxo6m8CkJHWKLGE8Dc0WgBi1hmfy4hqnI github-action-emilyvansant"
      ];

      staticWebsite = {
        domain = "emilyvansant.com";
        webRoot = "/var/www/emilyvansant";
      };
    };
  };
}
