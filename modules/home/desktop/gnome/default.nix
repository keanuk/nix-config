{
  flake.modules.homeManager.gnome = _: {
    imports = [
      ./_keyring.nix
    ];

    dconf.settings = {
      "org/gnome/desktop/datetime".automatic-timezone = true;
      "org/gnome/system/location".enabled = true;
    };
  };
}
