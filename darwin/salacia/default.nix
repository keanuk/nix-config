{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    inputs.home-manager.darwinModules.home-manager

    ../_mixins/base
    ../_mixins/base/homebrew-aarch.nix

    ../_mixins/user/keanu
  ];

  networking.hostName = "salacia";

  homebrew.caskArgs.appdir = "/Volumes/SALACIA-EXT/Applications";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/salacia/keanu.nix];
  };

  system.stateVersion = 6;
}
