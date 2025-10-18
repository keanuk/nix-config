{lib, ...}: {
  imports = [
    ./packages.nix

    ./alacritty/default.nix
    ./amberol/default.nix
    ./appearance/default.nix
    ./chromium/default.nix
    ./firefox/default.nix
    ./ghostty/default.nix
    ./halloy/default.nix
    ./kitty/default.nix
    ./ptyxis/default.nix
    ./thunderbird/default.nix
    ./vscode/default.nix
    ./zed/default.nix

    ../dev/default.nix
    ../dev/nim.nix
  ];

  programs.zellij = {
    enableBashIntegration = lib.mkForce false;
    enableFishIntegration = lib.mkForce false;
    enableZshIntegration = lib.mkForce false;
    exitShellOnExit = lib.mkForce false;
  };
}
