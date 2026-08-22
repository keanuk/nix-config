# NOTE: Not imported by any host; kept intentionally for future use.
{
  flake.modules.nixos.jackett = _: {
    services.jackett = {
      enable = true;
      openFirewall = true;
      user = "jackett";
      group = "media";
    };

    users.users.jackett.extraGroups = [
      "data"
    ];
  };
}
