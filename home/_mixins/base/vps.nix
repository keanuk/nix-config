{ outputs, ... }:
{
  imports = [
    ../shell

    ../fixes
  ];

  # nixpkgs config for standalone home-manager usage (homeConfigurations in flake.nix).
  # When used as a NixOS module with useGlobalPkgs = true, these are inherited from NixOS instead.
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
      outputs.overlays.stable-packages
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config = {
      allowUnfree = true;
    };
  };

  programs.home-manager = {
    enable = true;
  };

  news.display = "notify";
}
