{pkgs, ...}: {
  services.cockpit = {
    enable = true;
    package = pkgs.cockpit;
    openFirewall = true;
    port = 9090;
  };
}
