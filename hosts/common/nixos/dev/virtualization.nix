{ pkgs, ... }:

{
  virtualisation = {
    containerd.enable = true;
    docker.enable = true;
    podman.enable = true;
  };
  
  users.users.keanu.packages = with pkgs; [
    dockerfile-language-server-nodejs
  ];
}
