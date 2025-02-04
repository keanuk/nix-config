{ inputs, outputs, nix-colors, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disko-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    ../common/nixos/base/default.nix
    ../common/nixos/base/ephemeral-boot-luks-btrfs.nix
    # ../common/nixos/base/impermanence.nix
    # ../common/nixos/base/lanzaboote.nix
    ../common/nixos/base/systemd-boot.nix
    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/gnome.nix
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
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.keanu.imports = [ ../../home/miranda.nix ];
  };

  system.stateVersion = "24.11";
}
