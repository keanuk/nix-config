{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.element-desktop = {
        enable = true;
        # TODO: switch back to unstable when build succeeds
        package = pkgs.stable.element-desktop;
      };
    };
}
