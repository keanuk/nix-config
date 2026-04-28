{ config, ... }:
{
  flake.modules.homeManager.zig =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        zig
        zls
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.zig;
}
