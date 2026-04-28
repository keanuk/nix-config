{ config, ... }:
{
  flake.modules.nixos = {
    smartd =
      { lib, ... }:
      {
        services.smartd = {
          enable = lib.mkDefault true;
        };
      };

    pc = config.flake.modules.nixos.smartd;
    laptop = config.flake.modules.nixos.smartd;
    server = config.flake.modules.nixos.smartd;
  };
}
