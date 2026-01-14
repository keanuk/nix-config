{
  inputs,
  outputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-configuration.nix

    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ../_mixins/base
    ../_mixins/base/lanzaboote.nix
    ../_mixins/base/laptop.nix
    ../_mixins/base/systemd-boot.nix

    ../_mixins/services/btrfs

    ../_mixins/desktop
    ../_mixins/desktop/cosmic

    ../_mixins/user/keanu
  ];

  networking.hostName = "miranda";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [ ../../home/miranda/keanu.nix ];
  };

  system.stateVersion = "25.05";
}
