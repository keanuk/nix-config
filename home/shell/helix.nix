{ pkgs, lib, ... }:

{
  programs.helix = {
    enable = true;
    package = pkgs.helix;
    defaultEditor = true;
    settings = {
      theme = lib.mkDefault "catppuccin_mocha";
      editor = {
        auto-save = true;
        bufferline = "multiple";
        color-modes = true;
        cursorline = true;
        cursorcolumn = false;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
          deduplicate-links = false;
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
        scrolloff = 10;
        statusline = {
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
        true-color = true;
      };
      keys = {
        insert = { };
        normal = {
          space.space = "file_picker";
        };
        select = { };
      };
    };
  };

  home.packages = with pkgs; [
    helix-gpt
  ];
}
