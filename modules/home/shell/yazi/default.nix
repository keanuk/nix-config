{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        package = pkgs.yazi;
        enableBashIntegration = false;
        enableFishIntegration = true;
        enableNushellIntegration = false;
        enableZshIntegration = false;
        shellWrapperName = "y";
        theme = {
          flavor = {
            use = "catppuccin-mocha";
          };
        };
      };
    };
}
