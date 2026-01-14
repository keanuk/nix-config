{ lib, ... }:
{
  home.file."Library/Application Support/com.mitchellh.ghostty/config".source = ./config;

  programs.zellij = {
    enableBashIntegration = lib.mkForce false;
    enableFishIntegration = lib.mkForce false;
    enableZshIntegration = lib.mkForce false;
    exitShellOnExit = lib.mkForce false;
  };
}
