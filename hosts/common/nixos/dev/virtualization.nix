{ pkgs, ... }:

{
  virtualisation = {
    containerd.enable = true;
    docker.enable = true;
    podman.enable = true;

    oci-containers = {
      backend = "docker";
    };
  };

  environment.systemPackages = with pkgs; [
    arion
    docker-compose
  ];

  users.users.keanu.packages = with pkgs; [
    dockerfile-language-server-nodejs
    kubernetes
  ];
}
