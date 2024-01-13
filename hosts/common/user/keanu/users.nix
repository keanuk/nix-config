{ config, pkgs, ... }:

{
  users.users.keanu = {
    isNormalUser = true;
    home = "/home/keanu";
    description = "Keanu Kerr";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
    initialPassword = "keanu";
  };
}
