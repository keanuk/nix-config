{
  flake.modules.nixos.adguardhome = _: {
    services.adguardhome = {
      enable = true;
    };
  };
}
