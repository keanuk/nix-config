{ pkgs, inputs, outputs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix

    inputs.determinate.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    ../common/darwin/base/default.nix
    ../common/darwin/user/keanu/default.nix
  ];

  networking.hostName = "paladin";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.keanu = {
      imports = [ ../../home/paladin.nix ];
      home.stateVersion = "24.05";
    };
  };

  services.nix-daemon.enable = true;
  nix.package = lib.mkDefault pkgs.nixVersions.latest;

  nixpkgs.hostPlatform = "x86_64-darwin";
  system.stateVersion = 4;
}
