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
      # TODO: Remove when this is no longer required
      permittedInsecurePackages = [
        "qtwebengine-5.15.19"
      ];
    };
  };

  programs.home-manager = {
    enable = true;
    path = "$HOME/.config/nix-config";
  };

  news.display = "notify";
}
