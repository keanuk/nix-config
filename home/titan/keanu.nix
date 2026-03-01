{ ... }:
{
  imports = [
    ../_mixins/profiles/desktop-linux.nix
    ../_mixins/desktop/gaming.nix
  ];

  home.stateVersion = "23.11";
}
