{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    ./disko-configuration.nix
    ./hardware-configuration.nix

    ../_mixins/base
    ../_mixins/base/vps.nix
    ../_mixins/base/systemd-boot.nix

    ../_mixins/user/keanu
  ];

  networking.hostName = "bucaccio";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/bucaccio/keanu.nix];
  };

  system.stateVersion = "25.05";
}
