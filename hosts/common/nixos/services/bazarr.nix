{ ... }:

{
  services.bazarr = {
    enable = true;
    openFirewall = true;
    user = "bazarr";
    group = "media";
  };

  users.users.bazarr.extraGroups = [
    "data"
  ];
}
