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
  };
}
