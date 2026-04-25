{ pkgs, ... }:
{
  programs.fuse = {
    enable = true;
    package = pkgs.fuse3;
  };
}
