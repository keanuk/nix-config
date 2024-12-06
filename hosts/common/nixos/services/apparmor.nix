{ ... }:

{
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
  };

  services.dbus.apparmor = "enabled";
}
