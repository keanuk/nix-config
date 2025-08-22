{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    inputs.home-manager.darwinModules.home-manager
    inputs.stylix.nixosModules.stylix

    ../common/darwin/base/default.nix
    ../common/darwin/base/homebrew-aarch.nix

    ../common/darwin/user/keanu/default.nix
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
