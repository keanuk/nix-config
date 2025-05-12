{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    ../common/nixos/base/default.nix
    ../common/nixos/base/lanzaboote.nix

    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/cosmic.nix
    # ../common/nixos/desktop/hyprland.nix

    ../common/nixos/user/keanu/default.nix
  ];

  networking.hostName = "miranda";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/miranda/keanu.nix];
  };

  system.stateVersion = "25.05";
}
