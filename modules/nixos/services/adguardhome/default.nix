# NOTE: Not imported by any host; kept intentionally for future use.
{
  flake.modules.nixos.adguardhome = _: {
    services.adguardhome = {
      enable = true;
    };
  };
}
