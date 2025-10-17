{pkgs, ...}: {
  # User defined without UID, potentially a WSL limitation
  users.users.keanu = {
    isNormalUser = true;
    home = "/home/keanu";
    description = "Keanu Kerr";
    shell = pkgs.fish;
    initialPassword = "keanu";
  };
}
