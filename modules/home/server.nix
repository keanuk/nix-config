{ config, ... }:
{
  flake.modules.homeManager.server =
    { pkgs, ... }:
    {
      imports = with config.flake.modules.homeManager; [
        zellij
        opencode
      ];

      programs.zellij = {
        enableZshIntegration = true;
        enableFishIntegration = true;
        exitShellOnExit = true;
      };

      home.packages = with pkgs; [
        transmission_4
      ];
    };
}
