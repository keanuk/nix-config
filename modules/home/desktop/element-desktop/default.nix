{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.element-desktop = {
        enable = true;
        package = pkgs.element-desktop;
      };
    };
}
