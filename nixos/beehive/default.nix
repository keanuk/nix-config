{
  inputs,
  outputs,
  mkHomeManagerHost,
  ...
}:
{
  imports = [
    # Flake inputs
    # TODO: Switch back to stable when 26.05 is released
    inputs.home-manager.nixosModules.home-manager

    # Hardware support
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # Host-specific hardware
    ./disko-configuration.nix
    ./hardware-configuration.nix
    # TODO: re-enable when RAID issues are resolved
    # ./raid-configuration.nix

    # Base configuration
    ../_mixins/base
    ../_mixins/base/amd.nix
    ../_mixins/base/hardware.nix
    ../_mixins/base/server.nix
    ../_mixins/base/systemd-boot.nix

    # Services
    ../_mixins/services/btrfs
    ../_mixins/services/ollama

    # User configuration
    ../_mixins/user/keanu

    # Home Manager
    (mkHomeManagerHost {
      inherit inputs outputs;
      users.keanu = ../../home/beehive/keanu.nix;
    })
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "beehive";

  services.ollama.loadModels = [
    "codestral:latest"
    "deepseek-r1:latest"
    "devstral-small-2:latest"
    "gemma3:latest"
    "gemma3n:latest"
    "gpt-oss:latest"
    "magistral:latest"
    "mistral:latest"
    "qwen3:latest"
    "qwen3-coder:latest"
  ];

  system.stateVersion = "25.05";
}
