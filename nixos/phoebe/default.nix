{
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko-btrfs.nix

    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5

    ../_mixins/base/amd.nix
    ../_mixins/base/default.nix
    ../_mixins/base/lanzaboote.nix
    ../_mixins/base/laptop.nix
    ../_mixins/base/systemd-boot.nix

    ../_mixins/desktop/default.nix
    ../_mixins/desktop/cosmic/default.nix

    ../_mixins/services/btrfs/default.nix
    ../_mixins/services/ollama/default.nix

    ../_mixins/user/keanu/default.nix
  ];

  networking.hostName = "phoebe";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/phoebe/keanu.nix];
  };

  services.ollama.rocmOverrideGfx = lib.mkForce "11.0.2";

  system.stateVersion = "25.11";
}
