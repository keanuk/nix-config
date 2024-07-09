{ pkgs, ... }:

{
  services.readarr = {
    enable = true;
    openFirewall = true;
    user = "readarr";
    group = "media";
    package = pkgs.unstable.readarr;
  };

  users.users.readarr.extraGroups = [
    "data"
  ];
}
