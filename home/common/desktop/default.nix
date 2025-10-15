{ lib, ...}: {
  imports = [
    ./packages.nix

    ./alacritty/alacritty.nix
    ./amberol/amberol.nix
    ./appearance/catppuccin.nix
    ./appearance/font.nix
    ./chromium/chromium.nix
    ./firefox/firefox.nix
    ./ghostty/ghostty.nix
    ./halloy/halloy.nix
    ./kitty/kitty.nix
    ./ptyxis/ptyxis.nix
    ./thunderbird/thunderbird.nix
    ./vscode/vscode.nix
    ./zed/zed.nix

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
