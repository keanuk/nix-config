{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.keanu = {
    isNormalUser = true;
    home = "/home/keanu";
    description = "Keanu Kerr";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    initialPassword = "keanu";
  };
}
