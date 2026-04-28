{
  flake.modules.nixos.samba = _: {
    services.samba = {
      enable = true;
    };
  };
}
