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

  services = {
    gpm.enable = true;
  };

  environment.systemPackages = with pkgs; [
    arion
    dockerfile-language-server
    kind
    kubernetes
    podman-compose
    podman-tui
  ];
}
