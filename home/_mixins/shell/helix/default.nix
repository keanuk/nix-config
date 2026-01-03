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
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
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
        bash-language-server = {
          command = "${pkgs.bash-language-server}/bin/bash-language-server";
          args = ["start"];
        };
        gopls = {
          command = "${pkgs.gopls}/bin/gopls";
        };
        marksman = {
          command = "${pkgs.marksman}/bin/marksman";
        };
        nil = {
          command = "${pkgs.nil}/bin/nil";
        };
        pylsp = {
          command = "${pkgs.python313Packages.python-lsp-server}/bin/pylsp";
        };
        rust-analyzer = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        };
        taplo = {
          command = "${pkgs.taplo}/bin/taplo";
          args = [
            "lsp"
            "stdio"
          ];
        };
        typescript-language-server = {
          command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
          args = ["--stdio"];
        };
        yaml-language-server = {
          command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
          args = ["--stdio"];
        };
        lsp-ai = {
          command = "lsp-ai";
          args = ["--use-separate-log-file"];
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
              parameters = {
                max-tokens = 1024;
                max-context = 4096;
                system = "You are a helpful coding assistant.";
              };
            };
          };
        };
      };
      language = [
        {
          name = "bash";
          language-servers = [
            "bash-language-server"
            "lsp-ai"
          ];
        }
        {
          name = "go";
          language-servers = [
            "gopls"
            "lsp-ai"
          ];
        }
        {
          name = "markdown";
          language-servers = [
            "marksman"
            "lsp-ai"
          ];
        }
        {
          name = "nix";
          language-servers = [
            "nil"
            "lsp-ai"
          ];
        }
        {
          name = "python";
          language-servers = [
            "pylsp"
            "lsp-ai"
          ];
        }
        {
          name = "rust";
          language-servers = [
            "rust-analyzer"
            "lsp-ai"
          ];
        }
        {
          name = "toml";
          language-servers = [
            "taplo"
            "lsp-ai"
          ];
        }
        {
          name = "typescript";
          language-servers = [
            "typescript-language-server"
            "lsp-ai"
          ];
        }
        {
          name = "yaml";
          language-servers = [
            "yaml-language-server"
            "lsp-ai"
          ];
        }
      ];
    };
  };
}
