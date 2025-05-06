{ pkgs, ... }:

{
  services.amberol = {
    enable = true;
    enableRecoloring = true;
    replayagain = "album";
    package = pkgs.amberol;
  };
}
