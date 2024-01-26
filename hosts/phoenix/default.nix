{ pkgs, inputs, outputs, ... }: {
	imports = [
		./hardware-configuration.nix

    # inputs.home-manager.nixosModules.home-manager
		../common/darwin/default.nix
	];

  networking.hostName = "phoenix";

  # home-manager = {
  #   extraSpecialArgs = { inherit inputs outputs; };
  #   useUserPackages = true;
  #   useGlobalPkgs = true;
  #   users.keanu = {
  #     imports = [ 
  #     ];
  #     home.stateVersion = "24.05";
  #   };
  # };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

	system.stateVersion = 4;
}