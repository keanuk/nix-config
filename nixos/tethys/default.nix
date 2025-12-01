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

    ../_mixins/base/fs.nix
    ../_mixins/base
    ../_mixins/base/server.nix
    ../_mixins/base/systemd-boot.nix

    ../_mixins/services/btrfs

    ../_mixins/desktop
    ../_mixins/desktop/cosmic

    ../_mixins/user/keanu

    # Change during next reinstall
    ../_mixins/base/swapfile.nix
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
