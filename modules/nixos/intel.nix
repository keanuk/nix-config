{ inputs, ... }:
{
  # Shared Intel hardware baseline. Laptop-specific power handling comes from
  # common-pc-laptop, which hosts add on top (it already includes common-pc).
  flake.modules.nixos.intel = {
    imports = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];
  };
}
