{ inputs, outputs, nix-colors, ... }: {
  imports = [
    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    ../common/nixos/base/fs.nix
    ../common/nixos/base/default.nix
    ../common/nixos/base/systemd-boot.nix
    ../common/nixos/desktop/hyprland.nix
    ../common/nixos/user/keanu/default.nix

    # Change during next reinstall
    ../common/nixos/base/swapfile.nix
  ];

  networking.hostName = "tethys";
  services.logrotate.checkConfig = false;

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs nix-colors; };
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [ ../../home/tethys/keanu.nix ];
  };

  system.stateVersion = "23.05";
}
