{ inputs, outputs, ... }: {
  imports = [
    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.hp-elitebook-845g8
    ../common/nixos/base/default.nix
    ../common/nixos/base/lanzaboote.nix
    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/gnome.nix
    ../common/nixos/desktop/hyprland.nix
    ../common/nixos/user/keanu/default.nix

    # Change during next reinstall
    ../common/nixos/base/swapfile.nix
    ../common/nixos/base/fs.nix
  ];

  networking.hostName = "enterprise";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.keanu = {
      imports = [ ../../home/enterprise.nix ];
      home.stateVersion = "23.11";
    };
  };

  system.stateVersion = "23.05";
}
