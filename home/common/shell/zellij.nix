{
  lib,
  pkgs,
  ...
}: {
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = true;
    attachExistingSession = true;
    exitShellOnExit = true;
    settings = {
      default_shell = "fish";
      mouse_mode = true;
      show_release_notes = true;
      show_startup_tips = false;
      pane_frames = true;
      default_mode = "normal";
      default_layout = "default";
      auto_layout = true;
      theme = lib.mkDefault "catppuccin-macchiato";
      simplified_ui = false;
      ui = {
        pane_frames = {
          hide_session_name = false;
          rounded_corners = true;
        };
      };
    };
  };
}
