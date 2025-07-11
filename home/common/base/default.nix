{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin

    ../shell/default.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.home-manager = {
    enable = true;
    path = "$HOME/.config/nix-config";
  };

  news.display = "notify";

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  programs.nh.flake = lib.mkForce "/Users/keanu/.config/nix-config";
}
