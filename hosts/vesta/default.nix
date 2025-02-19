{ inputs, outputs, nix-colors, ... }: {
  imports = [
    ./hardware-configuration.nix

    inputs.home-manager.darwinModules.home-manager

    ../common/darwin/base/default.nix
    ../common/darwin/user/keanu/default.nix
  ];

  networking.hostName = "vesta";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs nix-colors; };
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [ ../../home/vesta/keanu.nix ];
  };

  nixpkgs.hostPlatform = "x86_64-darwin";
  system.stateVersion = 4;
}
