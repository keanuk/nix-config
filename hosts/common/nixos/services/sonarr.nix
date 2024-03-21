{ ... }:

{
  services.sonarr = {
    enable = true;
    openFirewall = true;
    user = "sonarr";
    group = "media";
  };

  users.users.sonarr.extraGroups = [
    "data"
  ];
}
