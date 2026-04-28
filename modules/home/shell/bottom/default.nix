{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.bottom = {
        enable = true;
        package = pkgs.bottom;
      };
    };
}
