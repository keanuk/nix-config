{ inputs, outputs, nix-colors, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disko-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    inputs.nixos-cosmic.nixosModules.default
    inputs.catppuccin.nixosModules.catppuccin

    ../common/nixos/base/default.nix
    # ../common/nixos/base/ephemeral-boot-luks-btrfs.nix
    ../common/nixos/base/impermanence.nix
    ../common/nixos/base/lanzaboote.nix
    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/cosmic.nix
    ../common/nixos/desktop/hyprland.nix
    ../common/nixos/user/keanu/default.nix

    # Change during next reinstall
    ../common/nixos/base/swapfile.nix
    ../common/nixos/base/fs.nix
  ];

  networking.hostName = "miranda";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs nix-colors; };
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [ ../../home/miranda.nix ];
  };

  system.stateVersion = "25.05";
}
