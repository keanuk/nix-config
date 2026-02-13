{ lib, ... }:
{
  imports = [
    ./packages.nix

    ./alacritty
    ./amberol
    ./appearance
    ./chromium
    ./discord
    ./distrobox
    ./element-desktop
    ./firefox
    ./ghostty
    ./halloy
    ./kitty
    ./lutris
    ./ptyxis
    ./thunderbird
    ./vscode
    ./zed

    ../dev
  ];

  programs.zellij = {
    enableBashIntegration = lib.mkForce false;
    enableFishIntegration = lib.mkForce false;
    enableZshIntegration = lib.mkForce false;
    exitShellOnExit = lib.mkForce false;
  };
}
