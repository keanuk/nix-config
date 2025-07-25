{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager-stable.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    ./disko-configuration.nix
    ./hardware-configuration.nix
    ./raid-configuration.nix

    ../common/nixos/base/default.nix
    ../common/nixos/base/server.nix
    ../common/nixos/base/systemd-boot.nix

    ../common/nixos/user/keanu/default.nix
    ../common/nixos/user/keanu/data-groups.nix

    # TODO: Finish setting up disabled services
    ../common/nixos/services/bazarr.nix
    ../common/nixos/services/flaresolverr.nix
    # ../common/nixos/services/home-assistant.nix
    ../common/nixos/services/jellyfin.nix
    ../common/nixos/services/lidarr.nix
    # ../common/nixos/services/nextcloud.nix
    # ../common/nixos/services/nixarr.nix
    ../common/nixos/services/prowlarr.nix
    ../common/nixos/services/plex.nix
    ../common/nixos/services/radarr.nix
    ../common/nixos/services/sonarr.nix
    # ../common/nixos/services/transmission.nix
  ];

  networking.hostName = "earth";

  # networking.firewall = {
  #   allowedTCPPorts = [ 9091 51413 51820 ];
  #   allowedUDPPorts = [ 9091 51413 51820 ];
  # };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/earth/keanu.nix];
  };

  system.stateVersion = "23.11";
}
