{ inputs, pkgs, config, ... }: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    image = ../../../../../lib/wallpapers/blue-clouds.jpg;
    # image = config.lib.stylix.pixel "base0A";    
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyodark.yaml";
    polarity = "dark";
    # targets.gnome.enable = false;
    # targets.gtk.enable = false;

    cursor = {
      package = pkgs.libadwaita;
      name = "Adwaita";
      size = 24;
    };

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.noto-fonts;
        name = "NotoMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts;
        name = "Noto Color Emoji";
      };
    };
  };
}
