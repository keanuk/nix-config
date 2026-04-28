{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.lazygit = {
        enable = true;
        package = pkgs.lazygit;
      };
    };
}
