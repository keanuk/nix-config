{ config, ... }:
{
  flake.modules.nixos.gamescope =
    { pkgs, ... }:
    {
      programs.gamescope = {
        enable = true;
        package = pkgs.gamescope;
      };

      environment.systemPackages = with pkgs; [
        gamescope-wsi
      ];
    };

  flake.modules.nixos.desktop = config.flake.modules.nixos.gamescope;
}
