{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.eza = {
        enable = true;
        package = pkgs.eza;
        enableBashIntegration = false;
        enableFishIntegration = true;
        enableNushellIntegration = false;
        enableZshIntegration = false;
      };
    };
}
