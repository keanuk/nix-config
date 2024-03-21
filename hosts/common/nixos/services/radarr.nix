{ ... }:

{
  services.radarr = {
    enable = true;
    openFirewall = true;
    user = "radarr";
    group = "media";
  };

  users.users.radarr.extraGroups = [
    "data"
  ];
}
