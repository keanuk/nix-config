{ ... }:

{
  services.readarr = {
    enable = true;
    openFirewall = true;
    user = "readarr";
    group = "media";
  };

  users.users.readarr.extraGroups = [
    "data"
  ];
}
