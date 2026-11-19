{ inputs, ... }:
{
  # Shared Intel hardware baseline. Laptop-specific power handling comes from
  # common-pc-laptop, which hosts add on top (it already includes common-pc).
  flake.modules.nixos.intel =
    { lib, ... }:
    {
      imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        inputs.nixos-hardware.nixosModules.common-pc
        inputs.nixos-hardware.nixosModules.common-pc-ssd
      ];

      services.thermald.enable = lib.mkDefault true;
    };
}
