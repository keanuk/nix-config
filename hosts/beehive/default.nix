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

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ./disko-configuration.nix
    ./hardware-configuration.nix
    ./raid-configuration.nix

    ../common/nixos/base/default.nix
    ../common/nixos/base/server.nix
    # ../common/nixos/base/lanzaboote.nix
    ../common/nixos/base/systemd-boot.nix

    ../common/nixos/user/keanu/default.nix
    # ../common/nixos/user/keanu/data-groups.nix

    # TODO: Finish setting up disabled services
    ../common/nixos/services/btrfs.nix
    ../common/nixos/services/flaresolverr.nix
    ../common/nixos/services/home-assistant.nix
    # ../common/nixos/services/nextcloud.nix
    ../common/nixos/services/nixarr.nix
    ../common/nixos/services/ollama.nix
    ../common/nixos/services/open-webui.nix
    ../common/nixos/services/plex.nix
    # ../common/nixos/services/transmission.nix
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
