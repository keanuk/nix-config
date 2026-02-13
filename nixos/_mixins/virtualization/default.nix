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
    # TODO: remove unstable when added to stable
    unstable.dockerfile-language-server
    kind
    kubernetes
    podman-compose
    podman-tui
  ];
}
