{pkgs, ...}: {
  services.open-webui = {
    enable = true;
    package = pkgs.unstable.open-webui;
    openFirewall = true;
    host = "0.0.0.0";
    port = 11435;
  };
}
