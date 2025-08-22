{
  pkgs,
  lib,
  ...
}: {
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.qogir-icon-theme;
      name = lib.mkDefault "Qogir-Light";
    }
  };
}
