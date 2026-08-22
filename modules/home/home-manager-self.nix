{
  flake.modules.homeManager.home-manager-self =
    { config, ... }:
    {
      services.home-manager.autoUpgrade = {
        enable = true;
        frequency = "weekly";
        useFlake = true;
        flakeDir = "${config.home.homeDirectory}/.config/nix-config";
        preSwitchCommands = [ ];
      };
    };
}
