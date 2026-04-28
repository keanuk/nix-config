{ config, ... }:
{
  flake.modules.homeManager.nix =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixd
        nixdoc
        nixfmt
        nix-diff
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.nix;
}
