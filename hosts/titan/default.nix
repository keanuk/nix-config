{ pkgs, inputs, outputs, ... }: {
	imports = [
		./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote
    ../common/nixos/default.nix
    ../common/nixos/desktop/cosmic.nix
    ../common/nixos/desktop/desktop.nix
    ../common/nixos/desktop/gnome.nix
    ../common/nixos/packages/desktop.nix
    ../common/nixos/packages/packages.nix
    # ../common/nixos/server/mining.nix
    ../common/nixos/system/amd.nix
    ../common/nixos/system/btrfs.nix
    ../common/nixos/system/desktop.nix
    ../common/nixos/system/lanzaboote.nix
    ../common/nixos/system/network.nix
    ../common/nixos/system/system.nix
    ../common/nixos/user/keanu/users.nix
	];

  networking.hostName = "titan";

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
