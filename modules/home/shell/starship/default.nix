{
  flake.modules.homeManager.shell =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      noctaliaEnabled = config.programs.noctalia.enable or false;
      starshipToml = lib.importTOML ./starship.toml;
    in
    {
      programs.starship = {
        enable = true;
        package = pkgs.starship;
        enableTransience = true;
        enableInteractive = true;
        enableBashIntegration = false;
        enableFishIntegration = true;
        enableNushellIntegration = false;
        enableZshIntegration = false;
        settings = starshipToml // {
          palette = if noctaliaEnabled then "noctalia" else "catppuccin_mocha";
        };
      };
    };
}
