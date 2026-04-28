{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.ptyxis = {
        enable = true;
        package = pkgs.ptyxis;
      };
    };
}
