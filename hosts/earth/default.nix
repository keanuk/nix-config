{ pkgs, inputs, outputs, ... }: {
	imports = [
		./hardware-configuration.nix

		inputs.home-manager.nixosModules.home-manager
		../common/nix/configuration.nix
		../common/packages/packages.nix
		../common/packages/server.nix
		../common/server/data.nix
		../common/server/download.nix
		../common/server/media.nix
		../common/server/network.nix
		../common/system/btrfs.nix
		../common/system/network.nix
		../common/system/server.nix
		../common/system/system.nix
		../common/system/systemd-boot.nix
		../common/user/keanu/users.nix
	];

  networking.hostName = "earth";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.keanu = {
      imports = [ 
        ../common/user/keanu/server.nix
        ../common/user/keanu/home.nix
      ];
      home.stateVersion = "23.05";
    };
  };

  system.stateVersion = "23.05";
}