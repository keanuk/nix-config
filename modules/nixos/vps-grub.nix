{ config, ... }:
{
  flake.modules.nixos.vps-grub = {
    imports = with config.flake.modules.nixos; [ vps ];

    boot.loader.grub = {
      enable = true;
      efiSupport = false;
    };
  };
}
