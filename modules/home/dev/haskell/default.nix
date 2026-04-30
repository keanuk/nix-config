{ config, ... }:
{
  flake.modules.homeManager.haskell =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ghc
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.haskell;
}
