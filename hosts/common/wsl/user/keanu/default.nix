{pkgs, ...}: {
  wsl.defaultUser = "keanu"; 
  users.users.keanu = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/keanu";
    description = "Keanu Kerr";
    shell = pkgs.fish;
    initialPassword = "keanu";
  };
}
