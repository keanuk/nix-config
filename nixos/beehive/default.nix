{
  config,
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
    ../_mixins/services/ollama/full-models.nix

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

  # OpenClaw secrets (decrypted by sops-nix, readable by keanu's systemd user service)
  sops.secrets = {
    openclaw_telegram_bot_token_beehive = {
      owner = config.users.users.keanu.name;
    };
    openclaw_mistral_api_key = {
      owner = config.users.users.keanu.name;
    };
    openclaw_gateway_token = {
      owner = config.users.users.keanu.name;
    };
    openclaw_openai_api_key = {
      owner = config.users.users.keanu.name;
    };
  };

  system.stateVersion = "25.05";
}
