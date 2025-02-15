{ ... }:

{
  imports = [
    ./homebrew.nix
    ./packages.nix

    ../../dev/default.nix

    ../../desktop/fonts.nix
  ];

  # Disabled for Determinate Nix
  nix.enable = false;
}
