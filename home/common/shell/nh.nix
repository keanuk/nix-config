{
  pkgs,
  lib,
  ...
}: {
  programs.nh = {
    enable = true;
    package = pkgs.nh;
    flake = lib.mkDefault "/home/keanu/.config/nix-config";
    clean.enable = false;
  };
}
