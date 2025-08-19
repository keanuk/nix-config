{...}: {
  imports = [
    ./packages.nix

    ../desktop/ghostty/darwin.nix
    ../desktop/halloy/darwin.nix
    ../desktop/zed/darwin.nix

    ../shell/atuin/darwin.nix
    ../shell/nh/nh.nix

    ../dev/default.nix
  ];
}
