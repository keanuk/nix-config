{ inputs, pkgs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  home-manager.users.keanu.imports = [ 
    ../common/home-manager/desktop/hyprland.nix
  ];
}
