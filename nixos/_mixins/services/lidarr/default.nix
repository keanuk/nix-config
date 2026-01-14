{ pkgs, ... }:
{
  services.lidarr = {
    enable = true;
    openFirewall = true;
    user = "lidarr";
    group = "media";
    package = pkgs.unstable.lidarr;
  };

  users.users.lidarr.extraGroups = [
    "data"
  ];
}
