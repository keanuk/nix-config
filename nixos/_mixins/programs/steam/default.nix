{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    package = pkgs.steam;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    protontricks = {
      enable = true;
      package = pkgs.protontricks;
    };
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
