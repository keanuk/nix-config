{ config, ... }:
{
  flake.modules.nixos.nh =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.nh = {
        enable = true;
        package = pkgs.nh;
        flake = lib.mkDefault "${config.users.users.keanu.home}/.config/nix-config";
        clean.enable = false;
      };

      environment.variables.NH_NO_CHECKS = 1;
    };

  flake.modules.nixos.base = config.flake.modules.nixos.nh;
}
