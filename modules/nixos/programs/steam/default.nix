{ config, ... }:
{
  flake.modules.nixos.steam =
    { lib, pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        package = pkgs.steam;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = lib.mkDefault false;
        protontricks = {
          enable = true;
          package = pkgs.protontricks;
        };
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };

  flake.modules.nixos.desktop = config.flake.modules.nixos.steam;
}
