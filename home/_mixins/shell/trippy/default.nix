{ pkgs, ... }:
{
  programs.trippy = {
    enable = true;
    package = pkgs.trippy;
  };
}
