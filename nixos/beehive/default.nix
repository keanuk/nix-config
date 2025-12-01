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
    ../_mixins/base
    ../_mixins/base/server.nix
    ../_mixins/base/systemd-boot.nix

    ../_mixins/user/keanu

    ../_mixins/services/btrfs
    ../_mixins/services/flaresolverr
    ../_mixins/services/home-assistant
    ../_mixins/services/immich
    ../_mixins/services/nextcloud
    ../_mixins/services/nixarr
    ../_mixins/services/ollama
    ../_mixins/services/openvscode-server
    ../_mixins/services/open-webui
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
