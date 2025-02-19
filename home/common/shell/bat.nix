{ lib, pkgs, config, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = lib.mkDefault "${config.colorScheme.name}";
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
