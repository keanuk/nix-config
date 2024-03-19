{ ... }:

{
  services.plex = {
    enable = true;
    openFirewall = true;
    user = "keanu";
    group = "plex";
    dataDir = "/var/lib/plex";
  };
}
