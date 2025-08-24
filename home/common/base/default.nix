{outputs, ...}: {
  imports = [
    ../shell/default.nix
  ];

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
    path = "$HOME/.config/nix-config";
  };

  news.display = "notify";
}
