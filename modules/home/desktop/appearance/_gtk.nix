{
  pkgs,
  lib,
  ...
}:
{
  gtk = {
    enable = true;
    iconTheme = {
      package = lib.mkDefault pkgs.papirus-icon-theme;
      name = lib.mkDefault "Papirus-Dark";
    };
  };
}
