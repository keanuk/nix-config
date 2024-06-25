{ lib, pkgs, ... }:

{
  programs.gnome-shell = {
    theme = lib.mkForce null;
  };

  gtk = {
    theme = {
      package = lib.mkForce pkgs.libadwaita;
    };
  };
  
  dconf.settings = {
    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };
    "org/gnome/system/location" = {
      enabled = true;
    };
  };
}
