{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.discord = {
        enable = true;
        package = pkgs.discord;
      };
    };
}
