# NOTE: Not imported by any host; kept intentionally for future use.
{
  flake.modules.nixos.samba = _: {
    services.samba = {
      enable = true;
    };
  };
}
