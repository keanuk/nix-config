{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    image = "../../../../lib/wallpapers/pink-clouds.jpg";
    polarity = "either";
    base16Scheme = "catppuccin-mocha";
    icons = {
      enable = true;
      package = pkgs.qogir-icon-theme;
      light = "Qogir-Light";
      dark = "Qogir-Dark";
    };
    fonts = {
      sansSerif = {
        package = pkgs.roboto;
        name = "Roboto";
      };
      serif = {
        package = pkgs.roboto-slab;
        name = "Roboto Slab";
      };
      monospace = {
        package = pkgs.roboto-mono;
        name = "Roboto Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    targets.gnome = {
      enable = false;
      useWallpaper = false;
    };
  };
}
