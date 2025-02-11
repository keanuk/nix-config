{ inputs, outputs, nix-colors, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disko-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    inputs.nixos-cosmic.nixosModules.default
    inputs.catppuccin.nixosModules.catppuccin

    ../common/nixos/base/default.nix
    ../common/nixos/base/lanzaboote.nix
    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/gnome.nix
    ../common/nixos/desktop/hyprland.nix
    ../common/nixos/user/keanu/default.nix
  ];

  networking.hostName = "phoebe";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs nix-colors; };
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.keanu.imports = [ ../../home/phoebe.nix ];
  };

  system.stateVersion = "25.05";
}
