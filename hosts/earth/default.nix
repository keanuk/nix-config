{ inputs, outputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./disko-configuration.nix
    ./hardware-configuration.nix

    ../common/nixos/base/default.nix
    ../common/nixos/base/systemd-boot.nix
    ../common/nixos/user/keanu/default.nix

    # ../common/nixos/services/nixarr.nix
    ../common/nixos/services/jellyfin.nix
    ../common/nixos/services/lidarr.nix
    ../common/nixos/services/prowlarr.nix
    ../common/nixos/services/plex.nix
    ../common/nixos/services/radarr.nix
    ../common/nixos/services/sonarr.nix
    ../common/nixos/services/transmission.nix
  ];

  networking.hostName = "earth";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.keanu = {
      imports = [
        ../common/home-manager/default.nix
      ];
      home.stateVersion = "23.11";
    };
  };

  system.stateVersion = "23.11";
}
