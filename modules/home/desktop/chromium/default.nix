{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.chromium = {
        enable = true;
        # TODO: switch back to google-chrome when issues are resolved
        package = pkgs.chromium;
      };
    };
}
