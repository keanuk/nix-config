{
  pkgs,
  lib,
  ...
}: {
  gtk = {
    enable = true;
    iconTheme = {
      package = lib.mkDefault pkgs.qogir-icon-theme;
      name = lib.mkDefault "Qogir-Light";
    };
  };
}
