{ pkgs, ... }:
{
  services.homepage-dashboard = {
    enable = true;
    package = pkgs.unstable.homepage-dashboard;
    openFirewall = false;
    listenPort = 8082;
    allowedHosts = "oranos.org,localhost,127.0.0.1";
  };
}
