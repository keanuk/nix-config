{ config, ... }:
{
  flake.modules.nixos.evolution =
    { ... }:
    {
      programs.evolution = {
        enable = true;
      };
    };

  flake.modules.nixos.desktop = config.flake.modules.nixos.evolution;
}
