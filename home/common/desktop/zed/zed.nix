{
  pkgs,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    installRemoteServer = true;
    extensions = [
      "asciidoc"
      "basher"
      "cargo-tom"
      "catppuccin"
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
      vim_mode = true;
      vim = {
        default_mode = "helix_normal";
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
        Nix = {
          language_servers = [
            "nil"
            "!nixd"
          ];
          formatter = {
            external = {
              command = "alejandra";
            };
          };
        };
      };
      lsp = {
        nil.initialization_options.formatting.command = ["alejandra"];
      };
      features = {
        edit_prediction_provider = "copilot";
      };
      agent = {
        enabled = true;
        button = true;
        default_model = {
          provider = "copilot_chat";
          model = "claude-sonnet-4";
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
