{ pkgs, ... }:
{
  services.home-assistant = {
    enable = true;
    package = pkgs.unstable.home-assistant;
    configDir = "/data/.state/home-assistant";
    config = {
      default_config = { };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
    };
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

  systemd.services.home-assistant = {
    after = [ "raid-online.target" ];
    bindsTo = [ "raid-online.target" ];
    unitConfig.AssertPathIsMountPoint = "/data";
  };
}
