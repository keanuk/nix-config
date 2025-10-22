{pkgs, ...}: {
  services.home-assistant = {
    enable = true;
    package = pkgs.unstable.home-assistant;
    openFirewall = true;
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
      "mqtt"
      "zeroconf"
      "ssdp"
      "zha"
      "zigbee"

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
      "speedtest"

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
}
