{ config, ... }:
{
  flake.modules.nixos.apparmor = _: {
    security.apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
    };

    services.dbus.apparmor = "enabled";
  };

  flake.modules.nixos.base = config.flake.modules.nixos.apparmor;
}
