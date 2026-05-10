{
  flake.modules.homeManager.zellij =
    {
      lib,
      pkgs,
      ...
    }:
    {
      programs.zellij = {
        enable = true;
        package = pkgs.zellij;
        enableBashIntegration = lib.mkDefault false;
        enableZshIntegration = lib.mkDefault false;
        enableFishIntegration = lib.mkDefault false;
        attachExistingSession = false;
        exitShellOnExit = lib.mkDefault false;
        settings = {
          default_shell = "fish";
          mouse_mode = true;
          show_release_notes = true;
          show_startup_tips = false;
          pane_frames = true;
          default_mode = "normal";
          default_layout = "default";
          auto_layout = true;
          theme = lib.mkDefault "catppuccin-mocha";
          simplified_ui = false;
          ui = {
            pane_frames = {
              hide_session_name = false;
              rounded_corners = true;
            };
          };
        };
      };
    };
}
