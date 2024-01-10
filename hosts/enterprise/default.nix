{ pkgs, inputs, outputs, ... }: {
	imports = [
		./hardware-configuration.nix

    inputs.nixos-hardware.nixosModules.hp-elitebook-845g8
    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote
    ../common/desktop/cosmic.nix
    ../common/desktop/desktop.nix
    ../common/desktop/gnome.nix
    ../common/nix/configuration.nix
    ../common/packages/desktop.nix
    ../common/packages/packages.nix
    ../common/system/btrfs.nix
    ../common/system/desktop.nix
    ../common/system/lanzaboote.nix
    ../common/system/network.nix
    ../common/system/power.nix
    ../common/system/system.nix
    ../common/user/keanu/users.nix
	];

  networking.hostName = "enterprise";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.keanu = {
      imports = [ 
        ../common/user/keanu/desktop.nix
        ../common/user/keanu/home.nix
      ];
      home.stateVersion = "23.11";
    };
  };

  system.stateVersion = "23.05";
}