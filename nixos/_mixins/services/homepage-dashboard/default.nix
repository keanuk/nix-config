{pkgs, ...}: {
  services.homepage-dashboard = {
    enable = true;
    package = pkgs.unstable.homepage-dashboard;
    openFirewall = true;
    listenPort = 8082;
    allowedHosts = "oranos.me,localhost,127.0.0.1";
  };
}
