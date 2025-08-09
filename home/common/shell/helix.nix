{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;
    package = pkgs.helix;
    defaultEditor = true;
    extraPackages = with pkgs; [
      lsp-ai
    ];
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
        insert = {};
        normal = {
          space.space = "file_picker";
        };
        select = {};
      };
    };
    languages = {
      language-server = {
        lsp-ai = {
          command = "lsp-ai";
          args = ["--use-seperate-log-file"];
          config = {
            memory.file_store = {};
            models = {
              model1 = {
                type = "ollama";
                model = "codestral";
              };
              model2 = {
                type = "ollama";
                model = "qwen3-coder";
              };
            };
            completion = {
              model = "model1";
              parameters = {
                max-tokens = 64;
                max-context = 1024;
              };
            };
            chat = {
              trigger = "!C";
              action_display_name = "Chat";
              model = "model2";
              paramters = {
                max-tokens = 1024;
                max-context = 4096;
                system = "You are a helpful coding assistant.";
              };
            };
          };
        };
      };
    };
  };
}
