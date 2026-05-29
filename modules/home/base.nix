{
  flake.modules.homeManager.base =
    { ... }:
    {
      programs.home-manager = {
        enable = true;
      };

      news.display = "notify";
    };
}
