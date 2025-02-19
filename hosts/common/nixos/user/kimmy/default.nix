{ pkgs, ... }:

{
  users.users.kimmy = {
    isNormalUser = true;
    uid = 1001;
    home = "/home/kimmy";
    description = "Kimmy Bucaccio";
    extraGroups = [
      "networkmanager"
    ];
    shell = pkgs.nushell;
    initialPassword = "kimmy";
  };
}
