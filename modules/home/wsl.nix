{ config, ... }:
{
  flake.modules.homeManager.wsl =
    { lib, ... }:
    {
      imports = with config.flake.modules.homeManager; [
        base
        home-manager-self
        dev
      ];

      programs.zellij = {
        enableBashIntegration = lib.mkForce false;
        enableFishIntegration = lib.mkForce false;
        enableZshIntegration = lib.mkForce false;
        exitShellOnExit = lib.mkForce false;
      };
    };
}
