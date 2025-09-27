{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager-stable.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ./disko-configuration.nix
    ./hardware-configuration.nix

    ../common/nixos/base/default.nix
    ../common/nixos/base/pc.nix
    ../common/nixos/base/systemd-boot.nix

    ../common/nixos/user/keanu/default.nix

    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/cosmic.nix

    ../common/nixos/services/btrfs.nix
    ../common/nixos/services/ollama.nix
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
