{
  flake.modules.nixos.svc-adguardhome = _: {
    services.adguardhome = {
      enable = true;
    };
  };
}
