{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.fastfetch = {
        enable = true;
        package = pkgs.fastfetch;
      };
    };
}
