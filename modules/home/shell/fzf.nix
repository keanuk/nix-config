{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.fzf = {
        enable = true;
        package = pkgs.fzf;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
    };
}
