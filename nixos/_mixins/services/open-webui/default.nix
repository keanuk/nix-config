{pkgs, ...}: {
  services.open-webui = {
    enable = true;
    package = pkgs.unstable.open-webui;
    openFirewall = true;
    host = "127.0.0.1";
    port = 11435;
  };
}
