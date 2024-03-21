{ ... }:

{
  services.lidarr = {
    enable = true;
    openFirewall = true;
    user = "lidarr";
    group = "media";
  };

  users.users.lidarr.extraGroups = [
    "data"
  ];
}
