{ pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    installRemoteServer = true;
    extraPackages = with pkgs; [
      lsp-ai
    ];
    extensions = [
      "catppuccin"
      "csv"
      "dart"
      "docker-compose"
      "dockerfile"
      "golangci-lint"
      "graphql"
      "haskell"
      "html"
      "java"
      "kotlin"
      "lua"
      "make"
      "nix"
      "scss"
      "svelte"
      "sql"
      "toml"
      "xml"
      "zig"
    ];
    userSettings = {
      features = {
        edit_prediction_provider = "none";
      };
      autosave = "on_focus_change";
      restore_on_startup = "last_session";
      assistant = {
        default_model = {
          provider = "ollama";
          model = "deepseek-r1:latest";
        };
        version = "2";
      };
      ui_font_size = 16;
      buffer_font_size = 16;
      theme = {
        mode = "system";
        light = lib.mkDefault "Catppuccin Latte";
        dark = lib.mkDefault "Catppuccin Mocha";
      };
    };
  };
}
