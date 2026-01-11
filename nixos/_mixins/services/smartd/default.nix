{
  pkgs,
  lib,
  ...
}: {
  services.smartd = {
    enable = lib.mkDefault true;
  };
}
