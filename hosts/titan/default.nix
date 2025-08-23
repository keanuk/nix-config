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

    ../common/nixos/base/amd.nix
    ../common/nixos/base/default.nix
    ../common/nixos/base/lanzaboote.nix
    ../common/nixos/base/pc.nix
    ../common/nixos/base/systemd-boot.nix

    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/pantheon.nix

    ../common/nixos/services/btrfs.nix
    ../common/nixos/services/ollama.nix
    # ../common/nixos/services/open-webui.nix

    ../common/nixos/user/keanu/default.nix

    # Change during next reinstall
    ../common/nixos/base/swapfile.nix
    ../common/nixos/base/fs.nix
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
