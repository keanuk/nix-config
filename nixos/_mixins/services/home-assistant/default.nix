{ pkgs, ...}: {
  services.home-assistant = {
    enable = true;
    package = pkgs.unstable.home-assistant;
    openFirewall = true;
    config = {
      default_config = {};
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        time_zone = "EST";  
      };
    };
    extraComponents = [
      "analytics"
      "google_translate"
      "isal"
      "met"
      "mobile_app"
      "radio_browser"
      "shopping_list"
    ];
  };
}
