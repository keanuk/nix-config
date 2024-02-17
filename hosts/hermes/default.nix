{ pkgs, inputs, outputs, ... }: {
	imports = [
		./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote
    ../common/nixos/default.nix
    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/gnome.nix
    ../common/nixos/packages/default.nix
    ../common/nixos/packages/desktop.nix
    ../common/nixos/system/btrfs.nix
    ../common/nixos/system/default.nix
    ../common/nixos/system/lanzaboote.nix
    ../common/nixos/system/nix-unstable.nix
    ../common/nixos/user/keanu/default.nix
	];

  networking.hostName = "hermes";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.keanu = {
      imports = [ 
        ../common/home-manager/default.nix
        ../common/home-manager/desktop.nix
      ];
      home.stateVersion = "23.11";
    };
  };

  system.stateVersion = "23.05";
}