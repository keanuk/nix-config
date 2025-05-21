{
  pkgs,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    installRemoteServer = true;
    extraPackages = with pkgs; [
      lsp-ai
    ];
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
      features = {
        edit_prediction_provider = "none";
      };
      autosave = "on_focus_change";
      assistant.enabled = true;
      restore_on_startup = "last_session";
      tab_size = 2;
      assistant = {
        default_model = {
          provider = "ollama";
          model = "qwen3:latest";
        };
        version = "2";
      };
      ui_font_size = lib.mkDefault 14;
      buffer_font_size = lib.mkDefault 14;
      terminal = {
        button = true;
        dock = "bottom";
        font_family = "FiraCode Nerd Font";
        font_features = null;
        font_size = null;
        line_height = "comfortable";
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
        nix.binary.path_lookup = true;
        rust-analyzer.binary.path_lookup = true;
        zls.binary.path_lookup = true;
      };
    };
  };
}
