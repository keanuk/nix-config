{ config, ... }:
{
  flake.modules.nixos.laptop = {
    imports = with config.flake.modules.nixos; [ svc-smartd ];

    services = {
      thermald.enable = true;
    };
  };
}
