{ config, ... }:
{
  flake.modules.homeManager.server =
    { pkgs, ... }:
    {
      imports = with config.flake.modules.homeManager; [
        zellij
        opencode
      ];

      home.packages = with pkgs; [
        transmission_4
      ];
    };
}
