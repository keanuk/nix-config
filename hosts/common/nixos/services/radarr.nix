{ pkgs, ... }:

{
  services.radarr = {
    enable = true;
    openFirewall = true;
    user = "radarr";
    group = "media";
    package = pkgs.unstable.radarr;
  };

  users.users.radarr.extraGroups = [
    "data"
  ];
}
