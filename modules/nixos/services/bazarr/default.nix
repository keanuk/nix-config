# NOTE: Not imported by any host; kept intentionally for future use.
{
  flake.modules.nixos.bazarr = _: {
    services.bazarr = {
      enable = true;
      openFirewall = true;
      user = "bazarr";
      group = "media";
    };

    users.users.bazarr.extraGroups = [
      "data"
    ];
  };
}
