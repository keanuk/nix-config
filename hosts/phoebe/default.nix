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
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    inputs.stylix.nixosModules.stylix

    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5

    ../common/nixos/base/amd.nix
    ../common/nixos/base/default.nix
    ../common/nixos/base/lanzaboote.nix
    ../common/nixos/base/laptop.nix
    ../common/nixos/base/systemd-boot.nix

    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/cosmic.nix

    ../common/nixos/services/btrfs.nix
    ../common/nixos/services/ollama.nix

    ../common/nixos/user/keanu/default.nix
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
