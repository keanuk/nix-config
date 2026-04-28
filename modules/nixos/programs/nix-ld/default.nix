{ config, ... }:
{
  flake.modules.nixos.nix-ld =
    { pkgs, ... }:
    {
      programs.nix-ld = {
        enable = true;
        package = pkgs.nix-ld;
      };
    };

  flake.modules.nixos.base = config.flake.modules.nixos.nix-ld;
}
