{ lib, ... }:
{
  imports = [
    ../dev
  ];

  programs.zellij = {
    enableBashIntegration = lib.mkForce false;
    enableFishIntegration = lib.mkForce false;
    enableZshIntegration = lib.mkForce false;
    exitShellOnExit = lib.mkForce false;
  };
}
