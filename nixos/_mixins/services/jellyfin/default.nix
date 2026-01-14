{ pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "jellyfin";
    group = "media";
    package = pkgs.unstable.jellyfin;
  };

  users.users.jellyfin.extraGroups = [
    "data"
  ];
}
