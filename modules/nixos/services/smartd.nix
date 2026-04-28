{
  flake.modules.nixos.svc-smartd =
    { lib, ... }:
    {
      services.smartd = {
        enable = lib.mkDefault true;
      };
    };
}
