{
  flake.modules.nixos.svc-apparmor = _: {
    security.apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
    };

    services.dbus.apparmor = "enabled";
  };
}
