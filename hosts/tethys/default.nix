{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ../common/nixos/base/fs.nix
    ../common/nixos/base/default.nix
    ../common/nixos/base/server.nix
    ../common/nixos/base/systemd-boot.nix

    ../common/nixos/services/btrfs.nix

    ../common/nixos/desktop/cosmic.nix

    ../common/nixos/user/keanu/default.nix

    # Change during next reinstall
    ../common/nixos/base/swapfile.nix
  ];

  networking.hostName = "tethys";
  services.logrotate.checkConfig = false;

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/tethys/keanu.nix];
  };

  system.stateVersion = "23.05";
}
