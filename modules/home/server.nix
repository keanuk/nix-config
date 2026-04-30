{ config, pkgs, ... }:
{
  flake.modules.homeManager.server = {
    imports = with config.flake.modules.homeManager; [
      zellij
    ];

    home.packages = with pkgs; [
      transmission_4
    ];
  };
}
