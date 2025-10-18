{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    inputs.home-manager.darwinModules.home-manager

    ../_mixins/base/default.nix
    ../_mixins/user/keanu/default.nix
  ];

  networking.hostName = "charon";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/charon/keanu.nix];
  };

  nixpkgs.hostPlatform = "x86_64-darwin";
  system.stateVersion = 4;
}
