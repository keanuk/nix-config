{ inputs, outputs, lib, nix-colors, ... }: {
  imports = [
    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    inputs.nixos-hardware.nixosModules.hp-elitebook-845g8
    inputs.nixos-cosmic.nixosModules.default

    ../common/nixos/base/default.nix
    ../common/nixos/base/lanzaboote.nix

    ../common/nixos/desktop/default.nix
    ../common/nixos/desktop/pantheon.nix
    ../common/nixos/desktop/hyprland.nix

    ../common/nixos/user/keanu/default.nix
    ../common/nixos/user/kimmy/default.nix

    # TODO: change during next reinstall
    ../common/nixos/base/swapfile.nix
    ../common/nixos/base/fs.nix
  ];

  networking.hostName = "hyperion";


  i18n.defaultLocale = lib.mkForce "en_US.UTF-8";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs nix-colors; };
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users.keanu.imports = [ ../../home/hyperion/keanu.nix ];
    users.kimmy.imports = [ ../../home/hyperion/kimmy.nix ];
  };

  system.stateVersion = "23.05";
}
