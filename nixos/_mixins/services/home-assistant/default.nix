{ pkgs, ...}: {
  services.home-assistant = {
    enable = true;
    package = pkgs.unstable.home-assistant;
    openFirewall = true;
    config = {
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        time_zone = "EST";  
      };
    };
  };
}
