{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = {
      window = {
        decorations = "none";
        dynamic_padding = true;
        padding = {
          x = 5;
          y = 5;
        };
        startup_mode = "Maximized";
      };
    };
  };
}
