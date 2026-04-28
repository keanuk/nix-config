{
  pkgs,
  lib,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    package = lib.mkDefault pkgs.zed-editor;
    extensions = [
      "asciidoc"
      "basher"
      "cargo-toml"
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
        light = lib.mkDefault "Catppuccin Latte";
        dark = lib.mkDefault "Catppuccin Mocha";
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
        yaml-language-server = {
          binary = {
            path = "${pkgs.yaml-language-server}/bin/yaml-language-server";
            arguments = [ "--stdio" ];
          };
        };
      };
      language_models = {
        opencode = {
          show_free_models = true;
          show_zen_models = true;
          show_go_models = true;
        };
        ollama = {
          api_url = "http://localhost:11434";
          available_models = [
            {
              name = "gemma4";
              display_name = "Gemma 4";
              max_tokens = 8192;
            }
          ];
        };
      };
      edit_predictions = {
        provider = "ollama";
      };
      agent_servers = {
        opencode = {
          type = "registry";
        };
        mistral-vibe = {
          type = "registry";
        };
        github-copilot-cli = {
          type = "registry";
        };
        gemini = {
          type = "registry";
        };
        codex-acp = {
          type = "registry";
        };
        claude-acp = {
          type = "registry";
        };
      };
      ssh_connections = [
        {
          host = "beehive";
          args = [ ];
          projects = [
            {
              paths = [
                "/home/keanu/.config/nix-config"
              ];
            }
          ];
        }
      ];
      agent = {
        enabled = true;
        tool_permissions.default = "allow";
        button = true;
        default_model = {
          provider = "opencode";
          model = "opencode-go/glm-5.1";
        };
      };
    };
    userKeymaps = [ ];
  };
}
