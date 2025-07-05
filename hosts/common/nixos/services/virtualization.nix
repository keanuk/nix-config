{pkgs, ...}: {
  virtualisation = {
    containerd.enable = true;
    docker = {
      enable = true;
    };
    podman = {
      enable = true;
      # dockerCompat = true;
    };

    oci-containers = {
      backend = "docker";
    };
  };

  services = {
    gpm.enable = true;
  };

  environment.systemPackages = with pkgs; [
    arion
    docker-compose
    dockerfile-language-server-nodejs
    kind
    kubernetes
    podman-compose
    podman-tui
  ];
}
