{
  config,
  pkgs,
  ...
}:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    cycle = false;
    location = "center";
    terminal = "alacritty";
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
    };

    theme = {
      "*" = {
        bg = mkLiteral "#1e1e2e";
        fg = mkLiteral "#cdd6f4";
        bg-alt = mkLiteral "#313244";
        fg-alt = mkLiteral "#a6adc8";
        highlight = mkLiteral "#89b4fa";
        urgent = mkLiteral "#f38ba8";
        transparent = mkLiteral "rgba(0,0,0,0)";
      };

      window = {
        width = mkLiteral "600px";
        border = mkLiteral "2px";
        border-color = mkLiteral "@highlight";
        background-color = mkLiteral "@bg";
        padding = mkLiteral "12px";
      };

      mainbox = {
        spacing = mkLiteral "10px";
        padding = mkLiteral "0";
        background-color = mkLiteral "@transparent";
        children = mkLiteral "[ inputbar, listview ]";
      };

      inputbar = {
        spacing = mkLiteral "8px";
        padding = mkLiteral "8px 12px";
        background-color = mkLiteral "@bg-alt";
        border-radius = mkLiteral "8px";
        children = mkLiteral "[ prompt, entry ]";
      };

      prompt = {
        text-color = mkLiteral "@highlight";
        font = mkLiteral "RobotoMono Nerd Font 14";
      };

      entry = {
        text-color = mkLiteral "@fg";
        placeholder = "Search...";
        placeholder-color = mkLiteral "@fg-alt";
        font = mkLiteral "Roboto 14";
      };

      listview = {
        lines = mkLiteral "10";
        spacing = mkLiteral "6px";
        padding = mkLiteral "0";
        background-color = mkLiteral "@transparent";
        fixed-height = mkLiteral "false";
        dynamic = mkLiteral "true";
      };

      element = {
        padding = mkLiteral "8px 12px";
        spacing = mkLiteral "8px";
        border-radius = mkLiteral "8px";
        background-color = mkLiteral "@transparent";
        text-color = mkLiteral "@fg";
      };

      "element selected" = {
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@highlight";
      };

      "element-icon" = {
        size = mkLiteral "24px";
      };

      "element-text" = {
        font = mkLiteral "Roboto 14";
      };

      mode-switcher = {
        spacing = mkLiteral "8px";
      };

      button = {
        padding = mkLiteral "6px 12px";
        border-radius = mkLiteral "8px";
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@fg-alt";
      };

      "button selected" = {
        background-color = mkLiteral "@highlight";
        text-color = mkLiteral "@bg";
      };
    };
  };
}
