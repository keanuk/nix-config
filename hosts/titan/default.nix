{ inputs, outputs, ... }: {
	imports = [
		./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    ../common/nixos/base/amd.nix
    ../common/nixos/base/btrfs.nix
    ../common/nixos/base/default.nix
    ../common/nixos/base/lanzaboote.nix
    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/plasma.nix
    ../common/nixos/user/keanu/default.nix
        
    # Change during next reinstall
    ../common/nixos/base/swapfile.nix
  ];

  networking.hostName = "titan";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.keanu = {
      imports = [
        ../common/home-manager/default.nix
        ../common/home-manager/desktop/default.nix
        ../common/home-manager/shell/nixvim.nix
      ];
      home.stateVersion = "23.11";
    };
  };

  system.stateVersion = "23.05";
}
