{...}: {
  imports = [
    ./homebrew.nix
    ./packages.nix

    ../../desktop/fonts.nix

    ../../programs/nh.nix
  ];

  # Disabled for Determinate Nix
  nix.enable = false;
}
