{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  ];

  users.users.keanu.packages = with pkgs; [
  ];

  environment.sessionVariables = {};
}
