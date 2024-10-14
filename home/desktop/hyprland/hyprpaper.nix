{ pkgs, inputs, lib, ... }:

{
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages."${pkgs.system}".default;
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
