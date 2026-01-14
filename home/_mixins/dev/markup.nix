{ pkgs, ... }:
{
  home.packages = with pkgs; [
    marksman
    taplo
    yaml-language-server
  ];
}
