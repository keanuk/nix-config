{
  flake.modules.nixos.svc-jackett = _: {
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
