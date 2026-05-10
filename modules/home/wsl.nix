{ config, ... }:
{
  flake.modules.homeManager.wsl =
    { ... }:
    {
      imports = with config.flake.modules.homeManager; [
        base
        home-manager-self
        dev
        opencode
      ];

    };
}
