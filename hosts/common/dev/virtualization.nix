{ pkgs, ... }:

{
  virtualisation = {
    containerd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
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
    podman-compose
    podman-desktop
    podman-tui
  ];

  users.users.keanu.packages = with pkgs; [
    dockerfile-language-server-nodejs
    kind
    kubernetes
  ];
}
