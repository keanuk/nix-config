{pkgs, ...}: {
  services.sonarr = {
    enable = true;
    openFirewall = true;
    user = "sonarr";
    group = "media";
    package = pkgs.unstable.sonarr;
  };

  users.users.sonarr.extraGroups = [
    "data"
  ];
}
