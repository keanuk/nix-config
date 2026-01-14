{
  inputs,
  outputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    inputs.nixos-hardware.nixosModules.hp-elitebook-845g8

    ../_mixins/base
    ../_mixins/base/lanzaboote.nix
    ../_mixins/base/laptop.nix
    ../_mixins/base/systemd-boot.nix

    ../_mixins/services/btrfs

    ../_mixins/desktop
    ../_mixins/desktop/pantheon

    ../_mixins/user/keanu
    ../_mixins/user/kimmy

    # TODO: change during next reinstall
    ../_mixins/base/swapfile.nix
    ../_mixins/base/fs.nix
  ];

  networking.hostName = "hyperion";

  i18n = {
    defaultLocale = lib.mkForce "en_US.UTF-8";
    extraLocaleSettings = lib.mkForce {
      LC_ALL = "en_US.UTF-8";
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [ ../../home/hyperion/keanu.nix ];
    users.kimmy.imports = [ ../../home/hyperion/kimmy.nix ];
  };

  system.stateVersion = "23.05";
}
