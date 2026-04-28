{ config, ... }:
{
  flake.modules.nixos.fuse = {
    programs.fuse = {
      enable = true;
    };
  };

  flake.modules.nixos.base = config.flake.modules.nixos.fuse;
}
