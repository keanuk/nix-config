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
      # TODO: remove electron when pocket-casts no longer depends on this
      # TODO: remove qtwebengine when issue is resolved: https://github.com/NixOS/nixpkgs/issues/437865
      permittedInsecurePackages = [
        "electron-35.7.5"
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
