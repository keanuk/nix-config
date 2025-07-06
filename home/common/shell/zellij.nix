{pkgs, ...}: {
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
      ui = {
        pane_frames = {
          rounded_corners = true;
        };
      };
    };
  };
}
