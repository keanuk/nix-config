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
      ui_font_size = 20;
      buffer_font_size = 20;
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
