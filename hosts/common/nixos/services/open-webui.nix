{ pkgs, ... }:

{
  services.open-webui = {
    enable = true;
    package = pkgs.open-webui;
    openFirewall = false;
    port = 11435;
  };
}
