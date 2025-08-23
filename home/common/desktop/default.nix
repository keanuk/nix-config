{...}: {
  imports = [
    ./packages.nix

    ./alacritty/alacritty.nix
    ./amberol/amberol.nix
    ./appearance/catppuccin.nix
    ./appearance/font.nix
    ./appearance/gtk.nix
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
}
