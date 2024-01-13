{ pkgs, inputs, outputs, ... }: {
	imports = [
		./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
	];

  networking.hostName = "phoenix";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.keanu = {
      imports = [ 
      ];
      home.stateVersion = "24.05";
    };
  };
}