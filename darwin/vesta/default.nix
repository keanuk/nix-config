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

  networking.hostName = "vesta";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/vesta/keanu.nix];
  };

  system.stateVersion = 4;
}
