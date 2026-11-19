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

  # Opt into desktop/workstation/server roles rather than base so minimal VPSes
  # do not pull podman/kubernetes/kind/arion closures.
  flake.modules.nixos = {
    pc = config.flake.modules.nixos.virtualization;
    laptop = config.flake.modules.nixos.virtualization;
    server = config.flake.modules.nixos.virtualization;
  };
}
