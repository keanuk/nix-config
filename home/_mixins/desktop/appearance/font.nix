{ lib, ... }:
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = lib.mkDefault [ "Roboto" ];
      serif = lib.mkDefault [ "Roboto Slab" ];
      monospace = lib.mkDefault [ "RobotoMono Nerd Font" ];
      emoji = lib.mkDefault [ "Noto Color Emoji" ];
    };
  };
}
