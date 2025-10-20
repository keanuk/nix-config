{pkgs, ...}: {
  services.immich = {
    enable = true;
    package = pkgs.unstable.immich;
    openFirewall = true;
  };
}
