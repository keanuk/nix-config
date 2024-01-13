{ pkgs, inputs, outputs, ... }: {
	imports = [
    inputs.home-manager.nixosModules.home-manager
    ../common/nix/configuration.nix
    ../common/packages/desktop.nix
    ../common/packages/packages.nix
    ../common/user/keanu/users.nix
	];

  networking.hostName = "phoenix";

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
}