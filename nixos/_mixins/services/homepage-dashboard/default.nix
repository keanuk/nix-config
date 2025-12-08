{pkgs, ...}: {
  services.homepage-dashboard = {
    enable = true;
    package = pkgs.unstable.homepage-dashboard;
    openFirewall = true;
    # Default port for homepage-dashboard web interface
    listenPort = 8082;
  };
}
