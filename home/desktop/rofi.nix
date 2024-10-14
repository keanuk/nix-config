{ config, pkgs, ... }:

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

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "element" = {
        padding = mkLiteral "1px";
        spacing = mkLiteral "5px";
        border = 0;
        cursor = mkLiteral "pointer";
      };
      "element-text" = {
        highlight = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
      };
      "element-icon" = {
        size = mkLiteral "1em";
        cursor = mkLiteral "inherit";
      };
      "window" = {
        padding = 5;
        border = 1;
      };
      "mainbox" = {
        padding = 0;
        border = 0;
      };
      "message" = {
        padding = mkLiteral "1px";
        border = 0;
      };
      "listview" = {
        padding = mkLiteral "2px 0px 0px";
        scrollbar = true;
        spacing = mkLiteral "2px";
        fixed-height = 0;
        border = 0;
      };
      "scrollbar" = {
        width = "4px";
        padding = 0;
        handle-width = "8px";
        border = 0;
      };
      "sidebar" = {
        border = 0;
      };
      "button" = {
        spacing = 0;
        cursor = mkLiteral "pointer";
      };
      "num-filtered-rows, num-rows" = {
        expand = false;
      };
      "textbox-num-sep" = {
        expand = false;
        str = "/";
      };
      "inputbar" = {
        padding = mkLiteral "1px";
        spacing = 0;
        children = mkLiteral "[prompt, textbox-prompt-colon, entry, num-filtered-rows, textbox-num-sep, num-rows, case-indicator]";
      };
      "case-indicator" = {
        spacing = 0;
      };
      "entry" = {
        spacing = 0;
        placeholder = "Type to filter";
        cursor = mkLiteral "text";
      };
      "prompt" = {
        spacing = 0;
      };
      "textbox-prompt-colon" = {
        margin = mkLiteral "0px 0.3em 0em 0em";
        expand = false;
        str = ":";
      };
      "mode-switch" = {
        border = 0;
      };
    };
  };
}
