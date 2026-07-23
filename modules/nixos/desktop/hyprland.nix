_: {
  # pkgs.hyprland is the upstream flake build via the hyprland overlays applied in
  # nix-settings.nix. The nixpkgs module covers the portal, xwayland, and session
  # registration with their defaults.
  flake.modules.nixos.hyprland = {
    programs.hyprland.enable = true;
  };
}
