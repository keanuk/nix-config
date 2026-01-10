{pkgs, ...}: {
  users.users.keanu = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/keanu";
    description = "Keanu Kerr";
    extraGroups = [
      "wheel"
      "networkmanager"
      "podman"
      "docker"
      "ollama"
    ];
    shell = pkgs.fish;
    initialPassword = "keanu";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWMzYrXSIYdnLCK+Tvg37gZtKhRimeo/0KuGc39jWen keanu@salacia"

      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDS5rawgaqa78S0s07aGlWgvHrVzb3QzUocqq51u0od3 github-action-bucaccio"
    ];
  };
}
