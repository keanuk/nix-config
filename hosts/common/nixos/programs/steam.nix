{pkgs, ...}: {
  programs.steam = {
    enable = true;
    package = pkgs.steam;
    protontricks = {
      enable = true;
      package = pkgs.protontricks;
    };
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
  };
}
