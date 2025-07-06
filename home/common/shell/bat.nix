{
  lib,
  pkgs,
  ...
}: {
  programs.bat = {
    enable = true;
    package = pkgs.bat;
    config = {
      theme = lib.mkDefault "Catppuccin Mocha";
    };
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
