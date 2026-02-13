{
  pkgs,
  lib,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    installRemoteServer = true;
    extensions = [
      "asciidoc"
      "basher"
      "cargo-tom"
      "catppuccin"
      "catppuccin-blur"
      "catppuccin-icons"
      "csv"
      "dart"
      "dockerfile"
      "docker-compose"
      "env"
      "git-firefly"
      "golangci-lint"
      "gosum"
      "graphql"
      "haskell"
      "helm"
      "html"
      "http"
      "java"
      "just"
      "kotlin"
      "log"
      "lua"
      "make"
      "nix"
      "nu"
      "proto"
      "pylsp"
      "scss"
      "sql"
      "svelte"
      "swift"
      "terraform"
      "toml"
      "typst"
      "vue"
      "xml"
      "zig"
    ];
    userSettings = {
      autosave = "on_focus_change";
      restore_on_startup = "last_session";
      tab_size = 2;
      helix_mode = true;
      vim = {
        default_mode = "normal";
        toggle_relative_line_numbers = true;
        use_system_clipboard = "always";
      };
      ui_font_size = lib.mkDefault 16;
      buffer_font_size = lib.mkDefault 16;
      terminal = {
        button = true;
        dock = "bottom";
        font_family = "RobotoMono Nerd Font";
        font_features = null;
        font_size = null;
        line_height = "standard";
        shell.program = "fish";
        toolbar.breadcrumbs = true;
        working_directory = "current_project_directory";
      };
      theme = {
        mode = "system";
        light = lib.mkForce "Catppuccin Latte";
        dark = lib.mkForce "Catppuccin Mocha";
      };
      languages = {
        Bash = {
          language_servers = [
            "bash-language-server"
          ];
        };
        Go = {
          language_servers = [
            "gopls"
          ];
        };
        Markdown = {
          language_servers = [
            "marksman"
          ];
        };
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
        };
        Python = {
          language_servers = [
            "pylsp"
          ];
        };
        Rust = {
          language_servers = [
            "rust-analyzer"
          ];
        };
        TOML = {
          language_servers = [
            "taplo"
          ];
        };
        TypeScript = {
          language_servers = [
            "typescript-language-server"
          ];
        };
        YAML = {
          language_servers = [
            "yaml-language-server"
          ];
        };
      };
      lsp = {
        bash-language-server = {
          binary = {
            path = "${pkgs.bash-language-server}/bin/bash-language-server";
            arguments = [ "start" ];
          };
        };
        gopls = {
          binary = {
            path = "${pkgs.gopls}/bin/gopls";
          };
        };
        marksman = {
          binary = {
            path = "${pkgs.marksman}/bin/marksman";
          };
        };
        nixd = {
          binary = {
            path = "${pkgs.nixd}/bin/nixd";
          };
          initialization_options.formatting.command = [ "nixfmt" ];
        };
        pylsp = {
          binary = {
            path = "${pkgs.python313Packages.python-lsp-server}/bin/pylsp";
          };
        };
        rust-analyzer = {
          binary = {
            path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          };
        };
        taplo = {
          binary = {
            path = "${pkgs.taplo}/bin/taplo";
            arguments = [
              "lsp"
              "stdio"
            ];
          };
        };
        yaml-language-server = {
          binary = {
            path = "${pkgs.yaml-language-server}/bin/yaml-language-server";
            arguments = [ "--stdio" ];
          };
        };
        lsp-ai = {
          initialization_options = {
            memory.file_store = { };
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
      edit_predictions = {
        provider = "copilot";
      };
      agent = {
        enabled = true;
        button = true;
        default_model = {
          provider = "copilot_chat";
          model = "claude-opus-4.6";
        };
      };
    };
    userKeymaps = [
      {
        context = "vim_mode == insert";
        bindings = {
          escape = "vim::SwitchToHelixNormalMode";
          "ctrl-[" = "vim::SwitchToHelixNormalMode";
          ctrl-c = "vim::SwitchToHelixNormalMode";
          ctrl-o = "vim::SwitchToHelixNormalMode";
        };
      }
      {
        context = "vim_mode == replace";
        bindings = {
          escape = "vim::SwitchToHelixNormalMode";
          "ctrl-[" = "vim::SwitchToHelixNormalMode";
          ctrl-c = "vim::SwitchToHelixNormalMode";
        };
      }
      {
        context = "vim_mode == visual";
        bindings = {
          escape = "vim::SwitchToHelixNormalMode";
          "ctrl-[" = "vim::SwitchToHelixNormalMode";
          ctrl-c = "vim::SwitchToHelixNormalMode";
        };
      }
      {
        context = "vim_mode == normal";
        bindings = {
          escape = "vim::SwitchToHelixNormalMode";
        };
      }
      {
        context = "vim_mode == helix_normal";
        bindings = {
          escape = "vim::SwitchToHelixNormalMode";
        };
      }
      {
        context = "(VimControl && !menu)";
        bindings = {
          escape = "vim::SwitchToHelixNormalMode";
          "ctrl-[" = "vim::SwitchToHelixNormalMode";
        };
      }
      {
        context = "((Editor && vim_mode == waiting) && (vim_operator == ys || vim_operator == cs))";
        bindings = {
          escape = "vim::SwitchToHelixNormalMode";
        };
      }
    ];
  };
}
