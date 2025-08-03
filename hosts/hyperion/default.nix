{
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    inputs.determinate.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    inputs.nixos-hardware.nixosModules.hp-elitebook-845g8

    ../common/nixos/base/default.nix
    ../common/nixos/base/lanzaboote.nix

    ../common/nixos/services/btrfs.nix

    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/pantheon.nix

    ../common/nixos/user/keanu/default.nix
    ../common/nixos/user/kimmy/default.nix

    # TODO: change during next reinstall
    ../common/nixos/base/swapfile.nix
    ../common/nixos/base/fs.nix
  ];

  networking.hostName = "hyperion";

  i18n = {
    defaultLocale = lib.mkForce "en_US.UTF-8";
    extraLocaleSettings = lib.mkForce {
      LC_ALL = "en_US.UTF-8";
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/hyperion/keanu.nix];
    users.kimmy.imports = [../../home/hyperion/kimmy.nix];
  };

  system.stateVersion = "23.05";
}
