{ pkgs, ... }:
let
  wallpaperDark = ../../../../lib/wallpapers/blue-clouds.jpg;
  wallpaperLight = ../../../../lib/wallpapers/pink-clouds.jpg;
in
{
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    settings = {
      ipc = "on";
      splash = false;
      preload = [
        "${wallpaperDark}"
        "${wallpaperLight}"
      ];
      wallpaper = [
        ", ${wallpaperDark}"
      ];
    };
  };
}
