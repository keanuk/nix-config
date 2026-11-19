# NOTE: Not imported by any host; kept intentionally for future use.
{ inputs, ... }:
{
  flake.modules.nixos.hyprland = {
    nixpkgs.overlays = [
      inputs.hyprland.overlays.hyprland-packages
      inputs.hyprland.overlays.hyprland-extras
    ];

    programs.hyprland.enable = true;
  };
}
