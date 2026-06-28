{
  flake.modules.homeManager.gnome = _: {
    dconf.settings = {
      "org/gnome/desktop/datetime".automatic-timezone = true;
      "org/gnome/system/location".enabled = true;
    };
  };
}
