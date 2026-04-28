{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.skim = {
        enable = true;
        package = pkgs.skim;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
    };
}
