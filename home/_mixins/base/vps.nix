{ outputs, ... }:
{
  imports = [
    ../fixes

    ../shell/bash
    ../shell/bat
    ../shell/bottom
    ../shell/carapace
    ../shell/eza
    ../shell/fastfetch
    ../shell/fd
    ../shell/fish
    ../shell/gh
    ../shell/git
    ../shell/helix
    ../shell/micro
    ../shell/ripgrep
    ../shell/skim
    ../shell/starship
    ../shell/yazi
    ../shell/zoxide
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
