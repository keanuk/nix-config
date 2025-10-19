{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    inputs.wsl.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    ../_mixins/base/wsl.nix

    ../_mixins/user/keanu/default.nix
  ];

  networking.hostName = "mars";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/mars/keanu.nix];
  };

  system.stateVersion = "25.11";
}
