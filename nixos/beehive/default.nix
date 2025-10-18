{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager-stable.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ./disko-configuration.nix
    ./hardware-configuration.nix
    ./raid-configuration.nix

    ../_mixins/base/amd.nix
    ../_mixins/base/default.nix
    ../_mixins/base/server.nix
    ../_mixins/base/systemd-boot.nix

    ../_mixins/user/keanu/default.nix

    # TODO: Finish setting up disabled services
    ../_mixins/services/btrfs/default.nix
    ../_mixins/services/flaresolverr/default.nix
    ../_mixins/services/home-assistant/default.nix
    # ../_mixins/services/nextcloud/default.nix
    ../_mixins/services/nixarr/default.nix
    # ../_mixins/services/ollama/default.nix
    # ../_mixins/services/open-webui/default.nix
  ];

  networking.hostName = "beehive";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/beehive/keanu.nix];
  };

  system.stateVersion = "25.05";
}
