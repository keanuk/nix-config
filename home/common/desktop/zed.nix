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
      };
      ui_font_size = lib.mkDefault 14;
      buffer_font_size = lib.mkDefault 14;
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
          model = "gpt-4o";
        };
      };
    };
  };
}
