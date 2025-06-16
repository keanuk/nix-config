{...}: {
  imports = [
    ./homebrew.nix
    ./packages.nix

    ../../desktop/fonts.nix
  ];

  # Disabled for Determinate Nix
  nix.enable = false;
}
