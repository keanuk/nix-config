{
  flake.modules.nixos.svc-samba = _: {
    services.samba = {
      enable = true;
    };
  };
}
