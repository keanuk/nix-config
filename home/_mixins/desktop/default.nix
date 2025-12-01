{lib, ...}: {
  imports = [
    ./packages.nix

    ./alacritty
    ./amberol
    ./appearance
    ./chromium
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
    ../dev/nim.nix
  ];

  programs.zellij = {
    enableBashIntegration = lib.mkForce false;
    enableFishIntegration = lib.mkForce false;
    enableZshIntegration = lib.mkForce false;
    exitShellOnExit = lib.mkForce false;
  };
}
