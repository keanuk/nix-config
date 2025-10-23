{pkgs, ...}: {
  services.home-assistant = {
    enable = true;
    package = pkgs.unstable.home-assistant;
    configDir = "/data/.state/home-assistant";
    config = null;
    extraComponents = [
      # Core components (needed for basic functionality)
      "default_config"
      "met"
      "esphome"

      # Common smart home platforms
      "homekit"
      "homekit_controller"
      "hue"

      # Media integrations
      "cast"
      "dlna_dmr"
      "plex"
      "media_player"

      # Network and discovery
      "dhcp"
      "bluetooth"
      "usb"
      "network"

      # Sensors and utilities
      "sun"
      "weather"
      "systemmonitor"

      # Additional useful components
      "google_translate"
      "shopping_list"
      "mobile_app"
      "radio_browser"
      "wake_on_lan"
      "rest"
      "webhook"
      "template"

      # Performance
      "isal"
      "stream"
    ];
  };

  # Ensure Home Assistant starts after RAID is mounted
  systemd.services.home-assistant = {
    after = ["mount-raid.service"];
    requires = ["mount-raid.service"];
    unitConfig = {
      AssertPathIsMountPoint = "/data";
    };
  };

  # Open firewall for Home Assistant web interface
  networking.firewall.allowedTCPPorts = [8123];
}
