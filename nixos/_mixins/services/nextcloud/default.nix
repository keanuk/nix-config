{pkgs, ...}: {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = builtins.getEnv "HOST";
    https = false;
    home = "/var/lib/nextcloud";
    datadir = "/data/nextcloud";
  };
}
