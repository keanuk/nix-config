{ lib, pkgs, config, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = lib.mkDefault "Catppuccin Mocha";
    };
    package = pkgs.bat;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
      batpipe
      batwatch
      prettybat
    ];
  };
}
