{
  flake.modules.homeManager.base =
    { lib, ... }:
    {
      # Shared theming switch: set by the noctalia role so apps can fall back
      # to static themes when noctalia isn't managing them. Defined in base so
      # consumers don't need the noctalia module imported to read it.
      options.theme.noctaliaManaged = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether Noctalia manages application themes from the wallpaper.";
      };

      config = {
        programs.home-manager = {
          enable = true;
        };

        news.display = "notify";
      };
    };
}
