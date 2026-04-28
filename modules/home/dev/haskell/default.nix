{ config, ... }:
{
  flake.modules.homeManager.haskell =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        haskell.compiler.ghc98
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.haskell;
}
