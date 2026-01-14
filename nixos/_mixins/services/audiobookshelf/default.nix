{ pkgs, ... }:
{
  services.audiobookshelf = {
    enable = true;
    openFirewall = true;
    user = "audiobookshelf";
    group = "media";
    package = pkgs.unstable.audiobookshelf;
  };

  users.users.sonarr.extraGroups = [
    "data"
  ];
}
