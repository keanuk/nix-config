{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
    nixdoc
    nixfmt
    nix-diff
  ];
}
