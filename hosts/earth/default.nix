{ pkgs, inputs, outputs, ... }: {
	imports = [
		./hardware-configuration.nix

		inputs.home-manager.nixosModules.home-manager
    ../common/nixos/default.nix
    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/gnome.nix
    ../common/nixos/packages/default.nix
    ../common/nixos/packages/desktop.nix
    ../common/nixos/services/data.nix
    ../common/nixos/services/download.nix
    ../common/nixos/services/media.nix
    ../common/nixos/services/network.nix
    ../common/nixos/system/btrfs.nix
    ../common/nixos/system/default.nix
    ../common/nixos/system/nix-stable.nix
    ../common/nixos/system/systemd-boot.nix
    ../common/nixos/user/keanu/default.nix
	];

  networking.hostName = "earth";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.keanu = {
      imports = [ 
        ../common/home-manager/default.nix
        ../common/home-manager/server.nix
      ];
      home.stateVersion = "23.11";
    };
  };

  system.stateVersion = "23.11";
}