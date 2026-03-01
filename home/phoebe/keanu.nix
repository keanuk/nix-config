{ ... }:
{
  imports = [
    ../_mixins/profiles/desktop-linux.nix
    ../_mixins/desktop/gaming.nix
  ];

  home.stateVersion = "25.11";
}
