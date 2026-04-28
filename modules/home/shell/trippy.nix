{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.trippy = {
        enable = true;
        package = pkgs.trippy;
      };
    };
}
