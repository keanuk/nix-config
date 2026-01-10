{
  pkgs,
  lib,
  ...
}: {
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
      };
      language = [
        {
          name = "bash";
          language-servers = [
            "bash-language-server"
          ];
        }
        {
          name = "go";
          language-servers = [
            "gopls"
          ];
        }
        {
          name = "markdown";
          language-servers = [
            "marksman"
          ];
        }
        {
          name = "nix";
          language-servers = [
            "nil"
          ];
        }
        {
          name = "python";
          language-servers = [
            "pylsp"
          ];
        }
        {
          name = "rust";
          language-servers = [
            "rust-analyzer"
          ];
        }
        {
          name = "toml";
          language-servers = [
            "taplo"
          ];
        }
        {
          name = "typescript";
          language-servers = [
            "typescript-language-server"
          ];
        }
        {
          name = "yaml";
          language-servers = [
            "yaml-language-server"
          ];
        }
      ];
    };
  };
}
