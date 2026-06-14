{
  flake.modules.nixos.niri =
    { pkgs, lib, ... }:
    {
      programs.niri = {
        enable = true;
        useNautilus = true;
      };

      services.displayManager.gdm.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
        config.niri = {
          default = lib.mkForce [ "gtk" ];
        };
      };
    };
}
