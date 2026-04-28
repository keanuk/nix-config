{
  flake.modules.nixos.systemd-boot =
    { lib, ... }:
    {
      boot.loader.systemd-boot.enable = lib.mkDefault true;
    };
}
