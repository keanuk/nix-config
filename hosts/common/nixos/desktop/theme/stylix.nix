{ inputs, pkgs, config, ... }: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    image = ../../../../../lib/wallpapers/galaxy.jpg;
    # image = config.lib.stylix.pixel "base0A";    
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    polarity = "dark";

    cursor = {
      package = pkgs.libadwaita;
      name = "Adwaita";
      size = 22;
    };
    
    fonts = {
      serif = {
        package = pkgs.inter;
        name = "Inter Serif";
      };

      sansSerif = {
        package = pkgs.inter;
        name = "Inter Sans";
      };

      monospace = {
        package = pkgs.inter;
        name = "Inter Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };  
  };
}
