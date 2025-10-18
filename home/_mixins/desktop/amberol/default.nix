{pkgs, ...}: {
  services.amberol = {
    enable = true;
    enableRecoloring = true;
    replaygain = "album";
    package = pkgs.amberol;
  };
}
