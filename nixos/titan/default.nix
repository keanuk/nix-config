{
  inputs,
  outputs,
  mkHomeManagerHost,
  lib,
  ...
}:
{
  imports = [
    # Flake inputs
    inputs.home-manager.nixosModules.home-manager

    # Hardware support
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # Host-specific hardware
    ./hardware-configuration.nix

    # Base configuration
    ../_mixins/base
    ../_mixins/base/amd.nix
    ../_mixins/base/hardware.nix
    ../_mixins/base/lanzaboote.nix
    ../_mixins/base/pc.nix
    ../_mixins/base/rtw88-fix.nix

    # Desktop environment
    ../_mixins/desktop
    ../_mixins/desktop/pantheon

    # Services
    ../_mixins/services/btrfs
    ../_mixins/services/ollama
    ../_mixins/services/ollama/full-models.nix

    # User configuration
    ../_mixins/user/keanu

    # TODO: Change during next reinstall
    ../_mixins/base/swapfile.nix
    ../_mixins/base/fs.nix

    # Home Manager
    (mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../home/titan/keanu.nix;
    })
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "titan";

  services.ollama.rocmOverrideGfx = lib.mkForce "10.3.0";

  system.stateVersion = "23.05";
}
