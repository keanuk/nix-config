{
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default

    ../common/nixos/base/amd.nix
    ../common/nixos/base/default.nix
    ../common/nixos/base/lanzaboote.nix

    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/cosmic.nix

    ../common/nixos/user/keanu/default.nix
  ];

  networking.hostName = "phoebe";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [../../home/phoebe/keanu.nix];
  };

  services.ollama.rocmOverrideGfx = lib.mkForce "11.0.2";

  system.stateVersion = "25.05";
}
