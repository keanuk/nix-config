{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.nh = {
    enable = true;
    package = pkgs.nh;
    flake = lib.mkDefault "${config.home.homeDirectory}/.config/nix-config";
    clean.enable = false;
  };
}
