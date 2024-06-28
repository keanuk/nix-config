{ inputs, pkgs, config, ... }: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    image = ../../../../../lib/wallpapers/galaxy.jpg;
    # image = config.lib.stylix.pixel "base0A";    
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    polarity = "dark";

    cursor = {
      package = pkgs.libadwaita;
      name = "Adwaita";
      size = 22;
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
