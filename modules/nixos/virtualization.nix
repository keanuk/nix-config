{ config, ... }:
{
  flake.modules.nixos.virtualization =
    { pkgs, ... }:
    {
      virtualisation = {
        podman = {
          enable = true;
          dockerCompat = true;
        };

        oci-containers = {
          backend = "podman";
        };
      };

      environment.systemPackages = with pkgs; [
        arion
        dockerfile-language-server
        kind
        kubernetes
        podman-compose
        podman-tui
      ];
    };

  flake.modules.nixos.base = config.flake.modules.nixos.virtualization;
}
