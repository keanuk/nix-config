{pkgs, ...}: {
  services.open-webui = {
    enable = true;
    package = pkgs.unstable.open-webui;
    openFirewall = true;
    port = 11435;
  };
}
