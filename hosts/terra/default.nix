{ pkgs, inputs, outputs, ... }: {
	imports = [
		./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    ../common/nixos/base/btrfs.nix
    ../common/nixos/base/default.nix
    ../common/nixos/base/systemd-boot.nix
    ../common/nixos/user/keanu/default.nix
  ];

  networking.hostName = "terra";
  services.logrotate.checkConfig = false;
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.keanu = {
      imports = [ 
        ../common/home-manager/default.nix
      ];
      home.stateVersion = "23.05";
    };
  };

  system.stateVersion = "23.05";
}
