{
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ../_mixins/base/amd.nix
    ../_mixins/base/default.nix
    ../_mixins/base/lanzaboote.nix
    ../_mixins/base/pc.nix
    ../_mixins/base/systemd-boot.nix

    ../_mixins/desktop/default.nix
    ../_mixins/desktop/cosmic/default.nix

    ../_mixins/services/btrfs/default.nix
    ../_mixins/services/ollama/default.nix

    ../_mixins/user/keanu/default.nix

    # Change during next reinstall
    ../_mixins/base/swapfile.nix
    ../_mixins/base/fs.nix
  ];

  networking.hostName = "titan";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/titan/keanu.nix];
  };

  services.ollama.rocmOverrideGfx = lib.mkForce "10.3.0";

  system.stateVersion = "23.05";
}
