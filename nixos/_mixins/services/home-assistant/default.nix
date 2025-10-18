{...}: {
  services.home-assistant = {
    enable = true;
    config = ./configuration.yaml;
  };
}
