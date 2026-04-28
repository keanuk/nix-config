{
  flake.modules.homeManager.home-manager-self = {
    services.home-manager.autoUpgrade = {
      enable = true;
      frequency = "weekly";
    };
  };
}
