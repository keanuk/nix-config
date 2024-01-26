{ pkgs, inputs, outputs, ... }: {
	imports = [
		./hardware-configuration.nix

		inputs.home-manager.nixosModules.home-manager
		../common/nixos/nix/configuration.nix
		../common/nixos/packages/packages.nix
		../common/nixos/packages/server.nix
		../common/nixos/server/data.nix
		../common/nixos/server/download.nix
		../common/nixos/server/media.nix
		../common/nixos/server/network.nix
		../common/nixos/system/btrfs.nix
		../common/nixos/system/network.nix
		../common/nixos/system/server.nix
		../common/nixos/system/system.nix
		../common/nixos/system/systemd-boot.nix
		../common/nixos/user/keanu/users.nix
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
      home.stateVersion = "23.05";
    };
  };

  system.stateVersion = "23.05";
}