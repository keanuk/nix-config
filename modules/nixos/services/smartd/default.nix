{ config, ... }:
{
  flake.modules.nixos.smartd =
    { lib, ... }:
    {
      services.smartd = {
        enable = lib.mkDefault true;
      };
    };

  flake.modules.nixos.pc = config.flake.modules.nixos.smartd;

  flake.modules.nixos.laptop = config.flake.modules.nixos.smartd;

  flake.modules.nixos.server = config.flake.modules.nixos.smartd;
}
