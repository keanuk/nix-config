{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.ripgrep = {
        enable = true;
        package = pkgs.ripgrep;
      };
    };
}
