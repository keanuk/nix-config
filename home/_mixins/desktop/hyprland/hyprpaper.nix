{ pkgs, ... }:
{
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "../../../lib/wallpapers/blue-clouds.jpg"
        "../../../lib/wallpapers/pink-clouds.jpg"
      ];

      wallpaper = [
        ", ../../../lib/wallpapers/blue-clouds.jpg"
      ];
    };
  };
}
