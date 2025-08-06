{...}: {
  imports = [
    ./alacritty.nix
    ./amberol.nix
    ./chromium.nix
    ./firefox.nix
    ./font.nix
    ./ghostty.nix
    ./halloy.nix
    ./kitty.nix
    ./packages.nix
    ./pass.nix
    ./ptyxis.nix
    ./thunderbird.nix
    ./vscode.nix
    ./zed.nix

    ../dev/default.nix
    ../dev/nim.nix
  ];
}
