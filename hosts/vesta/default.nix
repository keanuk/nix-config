{ pkgs, inputs, outputs, lib, nix-colors, ... }: {
  imports = [
    ./hardware-configuration.nix

    inputs.determinate.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    ../common/darwin/base/default.nix
    ../common/darwin/user/keanu/default.nix
  ];

  networking.hostName = "vesta";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs nix-colors; };
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.keanu.imports = [ ../../home/vesta.nix ];
  };

  nix.package = lib.mkDefault pkgs.nixVersions.latest;

  nixpkgs.hostPlatform = "x86_64-darwin";
  system.stateVersion = 4;
}
