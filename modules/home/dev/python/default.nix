{ config, ... }:
{
  flake.modules.homeManager.python =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        python314

        python314Packages.python-lsp-server
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.python;
}
