{pkgs, ...}: {
  services.open-webui = {
    enable = true;
    package = pkgs.open-webui;
    openFirewall = true;
    port = 11435;
  };
}
