{ ... }:

{
  imports = [
    ./alacritty.nix
    ./chromium.nix
    ./firefox.nix
    ./ghostty.nix
    ./kitty.nix
    ./packages.nix
    ./thunderbird.nix
    ./vscode.nix

    ../dev/default.nix
    ../dev/nim.nix
  ];
}
