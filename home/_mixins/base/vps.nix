{ outputs, ... }:
{
  imports = [
    ../fixes
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
  };

  news.display = "notify";
}
