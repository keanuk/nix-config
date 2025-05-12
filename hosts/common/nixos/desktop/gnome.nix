{pkgs, ...}: {
  services = {
    udev.packages = with pkgs; [gnome-settings-daemon];
    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverrides = ''
          [org.gnome.system]
          location='true'
        '';
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gnome-tweaks

    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.forge
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.tailscale-qs
  ];
}
