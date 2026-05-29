{
  flake.modules.homeManager.base = _: {
    programs.home-manager = {
      enable = true;
    };

    news.display = "notify";
  };
}
