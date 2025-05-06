{ ... }:

{
  imports = [
    ./alacritty.nix
    ./amberol.nix
    ./chromium.nix
    ./firefox.nix
    ./ghostty.nix
    ./kitty.nix
    ./packages.nix
    ./thunderbird.nix
    ./vscode.nix
    ./zed.nix

    ../dev/default.nix
    ../dev/nim.nix
  ];
}
