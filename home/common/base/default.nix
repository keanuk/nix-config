{
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin

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

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  # TODO: remove when issue is resolved: https://github.com/catppuccin/nix/issues/602
  catppuccin.firefox.profiles.default.enable = false;

  programs.nh.flake = lib.mkForce "/Users/keanu/.config/nix-config";
}
