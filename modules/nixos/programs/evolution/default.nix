{ config, ... }:
{
  flake.modules.nixos.evolution = _: {
    programs.evolution = {
      enable = true;
    };
  };

  flake.modules.nixos.desktop = config.flake.modules.nixos.evolution;
}
