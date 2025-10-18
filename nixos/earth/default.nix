{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ./disko-configuration.nix
    ./hardware-configuration.nix

    ../_mixins/base/default.nix
    ../_mixins/base/pc.nix
    ../_mixins/base/systemd-boot.nix

    ../_mixins/user/keanu/default.nix

    ../_mixins/desktop/default.nix
    ../_mixins/desktop/cosmic/default.nix

    ../_mixins/services/btrfs/default.nix
    ../_mixins/services/ollama/default.nix
  ];

  networking.hostName = "earth";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/earth/keanu.nix];
  };

  system.stateVersion = "23.11";
}
