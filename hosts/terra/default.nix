{ inputs, outputs, ... }: {
  imports = [
    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    ../common/nixos/base/fs.nix
    ../common/nixos/base/default.nix
    ../common/nixos/base/systemd-boot.nix
    ../common/nixos/desktop/hyprland.nix
    ../common/nixos/user/keanu/default.nix

    # Change during next reinstall
    ../common/nixos/base/swapfile.nix
  ];

  networking.hostName = "terra";
  services.logrotate.checkConfig = false;

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.keanu = {
      imports = [ ../../home/terra.nix ];
      home.stateVersion = "23.11";
    };
  };

  system.stateVersion = "23.05";
}
